// lib/ui/otp_page.dart

import 'package:flutter/material.dart';
import 'package:klinik_app/service/register_service.dart';
import 'package:klinik_app/ui/login.dart';

class OtpPage extends StatefulWidget {
  // 1. Tambahkan properti untuk menerima email
  final String email;

  // 2. Perbarui konstruktor untuk mewajibkan email
  const OtpPage({super.key, required this.email});

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  final _formKey = GlobalKey<FormState>();
  final _otpCtrl = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _otpCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text("Verifikasi OTP")),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 3. Tampilkan email yang diterima
              Text(
                "Kode OTP telah dikirim ke:",
                style: theme.textTheme.bodyLarge,
              ),
              Text(
                widget.email, // Gunakan widget.email untuk mengakses data
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
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
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: _isLoading ? null : _submitOtp,
                child:
                    _isLoading
                        ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(),
                        )
                        : const Text("VERIFIKASI"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submitOtp() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      try {
        bool success = await RegisterService().verifyOtp(
          email: widget.email,
          otp: _otpCtrl.text.trim(),
        );
        if (mounted && success) {
          _showSuccessDialog();
        } else {
          _showErrorDialog("Kode OTP salah atau sudah kedaluwarsa.");
        }
      } catch (e) {
        if (mounted) _showErrorDialog("Terjadi kesalahan: ${e.toString()}");
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => AlertDialog(
            title: const Text("Registrasi Berhasil"),
            content: const Text(
              "Akun Anda telah berhasil dibuat. Silakan login.",
            ),
            actions: [
              TextButton(
                child: const Text("OK"),
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const Login()),
                    (Route<dynamic> route) => false,
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
            title: const Text("Verifikasi Gagal"),
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
