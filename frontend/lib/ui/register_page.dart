import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:klinik_app/ui/otp_page.dart';
import '../service/register_service.dart';
import 'package:dio/dio.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _namaDepanCtrl = TextEditingController();
  final _namaBelakangCtrl = TextEditingController();
  final _jenisKelaminCtrl = TextEditingController();
  final _usernameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _konfirmasiPasswordCtrl = TextEditingController();
  final _ttlCtrl = TextEditingController();
  DateTime? _selectedDate;
  String? _ageText;

  bool _isLoading = false;
  // State untuk visibilitas password dipindahkan ke sini
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  @override
  void dispose() {
    // Selalu dispose controller untuk menghindari memory leak
    _namaDepanCtrl.dispose();
    _namaBelakangCtrl.dispose();
    _jenisKelaminCtrl.dispose();
    _usernameCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _konfirmasiPasswordCtrl.dispose();
    _ttlCtrl.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(1920),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _ttlCtrl.text = DateFormat('dd-MM-yyyy').format(picked);
        _calculateAge(picked);
      });
    }
  }

  void _calculateAge(DateTime birthDate) {
    final currentDate = DateTime.now();
    int years = currentDate.year - birthDate.year;
    int months = currentDate.month - birthDate.month;
    if (currentDate.day < birthDate.day) {
      months--;
    }
    if (months < 0) {
      years--;
      months += 12;
    }
    setState(() {
      _ageText = "Usia: $years tahun, $months bulan";
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Registrasi Akun Baru"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: theme.colorScheme.primary),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildTextField(_namaDepanCtrl, "Nama Depan", Icons.person),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _namaBelakangCtrl,
                  decoration: const InputDecoration(
                    labelText: "Nama Belakang (Opsional)",
                    prefixIcon: Icon(Icons.person),
                  ),
                ),
                const SizedBox(height: 20),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: "Jenis Kelamin",
                    prefixIcon: Icon(Icons.wc),
                  ),
                  items:
                      ["Laki-laki", "Perempuan"]
                          .map(
                            (String value) => DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            ),
                          )
                          .toList(),
                  onChanged: (String? newValue) {
                    if (newValue != null) _jenisKelaminCtrl.text = newValue;
                  },
                  validator:
                      (value) =>
                          (value == null || value.isEmpty)
                              ? 'Pilih jenis kelamin'
                              : null,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _ttlCtrl,
                  readOnly: true,
                  decoration: const InputDecoration(
                    labelText: "Tanggal Lahir",
                    prefixIcon: Icon(Icons.calendar_today),
                  ),
                  onTap: () => _selectDate(context),
                  validator:
                      (value) =>
                          (value?.isEmpty ?? true)
                              ? 'Pilih tanggal lahir'
                              : null,
                ),
                if (_ageText != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, left: 12.0),
                    child: Text(
                      _ageText!,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ),
                const SizedBox(height: 20),
                _buildTextField(
                  _usernameCtrl,
                  "Username",
                  Icons.person_outline,
                ),
                const SizedBox(height: 20),
                _buildTextField(_emailCtrl, "Email", Icons.email_outlined),
                const SizedBox(height: 20),
                _buildPasswordField(
                  controller: _passwordCtrl,
                  label: "Password",
                  isVisible: _isPasswordVisible,
                  onToggleVisibility: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  },
                ),
                const SizedBox(height: 20),
                _buildPasswordField(
                  controller: _konfirmasiPasswordCtrl,
                  label: "Konfirmasi Password",
                  isConfirmation: true,
                  isVisible: _isConfirmPasswordVisible,
                  onToggleVisibility: () {
                    setState(() {
                      _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                    });
                  },
                ),
                const SizedBox(height: 40),
                _buildRegisterButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label,
    IconData icon,
  ) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(labelText: label, prefixIcon: Icon(icon)),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '$label tidak boleh kosong';
        }
        if (label == "Email" && !RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
          return 'Format email tidak valid';
        }
        return null;
      },
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    required bool isVisible,
    required VoidCallback onToggleVisibility,
    bool isConfirmation = false,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: !isVisible,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: const Icon(Icons.lock_outline),
        suffixIcon: IconButton(
          icon: Icon(isVisible ? Icons.visibility : Icons.visibility_off),
          onPressed: onToggleVisibility,
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) return '$label tidak boleh kosong';
        if (value.length < 6) return 'Password minimal 6 karakter';
        if (isConfirmation && value != _passwordCtrl.text)
          return 'Konfirmasi Password tidak cocok';
        return null;
      },
    );
  }

  Widget _buildRegisterButton() {
    return ElevatedButton(
      onPressed: _isLoading ? null : _submitRegister,
      child:
          _isLoading
              ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(),
              )
              : const Text("DAPATKAN KODE OTP"),
    );
  }

  void _submitRegister() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      try {
        bool success = await RegisterService().requestOtp(
          namaDepan: _namaDepanCtrl.text.trim(),
          namaBelakang: _namaBelakangCtrl.text.trim(),
          jenisKelamin: _jenisKelaminCtrl.text,
          ttl:
              _selectedDate != null
                  ? DateFormat('yyyy-MM-dd').format(_selectedDate!)
                  : null,
          username: _usernameCtrl.text.trim(),
          email: _emailCtrl.text.trim(),
          password: _passwordCtrl.text,
        );
        if (mounted && success) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OtpPage(email: _emailCtrl.text.trim()),
            ),
          );
        } else {
          _showErrorDialog(
            "Gagal mengirim OTP. Email atau username mungkin sudah digunakan.",
          );
        }
      } catch (e) {
        String errorMessage = "Terjadi kesalahan. Silakan coba lagi.";
        if (e is DioException && e.response != null) {
          errorMessage =
              e.response!.data['message'] ??
              'Error tidak diketahui dari server.';
        } else {
          errorMessage = e.toString();
        }
        if (mounted) {
          _showErrorDialog(errorMessage);
        }
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text("Registrasi Gagal"),
            content: Text(message),
            actions: [
              TextButton(
                child: const Text("OK"),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
    );
  }
}
