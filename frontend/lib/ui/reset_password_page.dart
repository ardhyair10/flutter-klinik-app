// lib/ui/reset_password_page.dart

import 'package:flutter/material.dart';
import 'package:klinik_app/ui/login.dart';
import '../service/auth_service.dart';

class ResetPasswordPage extends StatefulWidget {
  final String email;
  const ResetPasswordPage({super.key, required this.email});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _otpCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _konfirmasiPasswordCtrl = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text("Buat Password Baru")),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text("Reset password untuk:", style: theme.textTheme.bodyLarge),
                Text(
                  widget.email,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 32),

                // Input untuk OTP
                TextFormField(
                  controller: _otpCtrl,
                  decoration: const InputDecoration(
                    labelText: "Kode OTP",
                    prefixIcon: Icon(Icons.pin),
                  ),
                  keyboardType: TextInputType.number,
                  validator:
                      (value) =>
                          (value?.isEmpty ?? true)
                              ? 'OTP tidak boleh kosong'
                              : null,
                ),
                const SizedBox(height: 20),

                // Input untuk Password Baru
                TextFormField(
                  controller: _passwordCtrl,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: "Password Baru",
                    prefixIcon: Icon(Icons.lock),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty)
                      return 'Password baru tidak boleh kosong';
                    if (value.length < 6) return 'Password minimal 6 karakter';
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Input untuk Konfirmasi Password
                TextFormField(
                  controller: _konfirmasiPasswordCtrl,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: "Konfirmasi Password Baru",
                    prefixIcon: Icon(Icons.lock_outline),
                  ),
                  validator: (value) {
                    if (value != _passwordCtrl.text)
                      return 'Konfirmasi password tidak cocok';
                    return null;
                  },
                ),
                const SizedBox(height: 40),

                // Tombol Simpan
                ElevatedButton(
                  onPressed: _isLoading ? null : _submitReset,
                  child:
                      _isLoading
                          ? const CircularProgressIndicator()
                          : const Text("SIMPAN PASSWORD BARU"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _submitReset() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      try {
        // Panggil service untuk mengirim data ke backend
        bool success = await AuthService().resetPassword(
          email: widget.email,
          otp: _otpCtrl.text.trim(),
          newPassword: _passwordCtrl.text.trim(),
        );

        if (mounted) {
          if (success) {
            // Jika backend merespon sukses, tampilkan dialog
            _showSuccessDialog();
          } else {
            // Jika backend merespon gagal (misal: OTP salah)
            _showErrorDialog(
              "Gagal mereset password. Pastikan kode OTP Anda benar.",
            );
          }
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

  // Pastikan Anda juga memiliki fungsi _showSuccessDialog dan _showErrorDialog
  // di dalam class _ResetPasswordPageState ini.

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => AlertDialog(
            title: const Text("Berhasil"),
            content: const Text(
              "Password Anda telah berhasil diubah. Silakan login kembali.",
            ),
            actions: [
              TextButton(
                child: const Text("OK"),
                onPressed: () {
                  // Kembali ke halaman login dan hapus semua halaman sebelumnya
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const Login()),
                    (route) => false,
                  );
                },
              ),
            ],
          ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text("Gagal"),
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
