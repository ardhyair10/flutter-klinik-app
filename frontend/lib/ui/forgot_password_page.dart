import 'package:flutter/material.dart';
import 'package:klinik_app/ui/reset_password_page.dart'; // Nanti kita buat halaman ini
import '../service/auth_service.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Lupa Password"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: theme.colorScheme.primary),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                "Reset Password",
                style: theme.textTheme.displaySmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                "Masukkan email akun Anda. Kami akan mengirimkan kode OTP untuk mereset password Anda.",
                style: theme.textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              TextFormField(
                controller: _emailCtrl,
                decoration: const InputDecoration(
                  labelText: "Email",
                  prefixIcon: Icon(Icons.email_outlined),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Email tidak boleh kosong';
                  }
                  if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                    return 'Format email tidak valid';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: _isLoading ? null : _submitRequest,
                child:
                    _isLoading
                        ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(),
                        )
                        : const Text("KIRIM KODE OTP"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submitRequest() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      try {
        // Panggil service yang sesungguhnya
        bool success = await AuthService().requestPasswordReset(
          _emailCtrl.text,
        );

        if (mounted && success) {
          // Tampilkan dialog info, lalu navigasi ke halaman reset
          showDialog(
            context: context,
            builder:
                (context) => AlertDialog(
                  title: const Text("Permintaan Terkirim"),
                  content: Text(
                    "Jika email ${_emailCtrl.text} terdaftar, Anda akan menerima kode OTP.",
                  ),
                  actions: [
                    TextButton(
                      child: const Text("OK"),
                      onPressed: () {
                        Navigator.of(context).pop(); // Tutup dialog
                        // Navigasi ke halaman reset password sambil membawa email
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder:
                                (context) =>
                                    ResetPasswordPage(email: _emailCtrl.text),
                          ),
                        );
                      },
                    ),
                  ],
                ),
          );
        } else {
          // Jika gagal (meskipun backend selalu merespon sukses), tampilkan error umum
          _showErrorDialog("Gagal mengirim permintaan. Coba lagi nanti.");
        }
      } catch (e) {
        if (mounted) {
          _showErrorDialog("Terjadi kesalahan: ${e.toString()}");
        }
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }

  // Tambahkan juga fungsi _showErrorDialog jika belum ada
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text("Error"),
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
