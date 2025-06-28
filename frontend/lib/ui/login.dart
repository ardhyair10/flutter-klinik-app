import 'package:flutter/material.dart';
import 'package:klinik_app/model/user.dart';
import 'package:klinik_app/service/login_service.dart';
import 'package:klinik_app/ui/beranda.dart';
import 'package:klinik_app/helpers/user_info.dart';
import 'package:klinik_app/ui/register_page.dart'; // Import halaman registrasi
import 'forgot_password_page.dart'; // <-- TAMBAHKAN BARIS INI

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  final _usernameCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _isLoading = false;
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                  Icon(
                    Icons.local_hospital_rounded,
                    size: 80,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Klinik App",
                    textAlign: TextAlign.center,
                    style: theme.textTheme.displaySmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Login Brow",
                    textAlign: TextAlign.center,
                    style: theme.textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 48),
                  _usernameTextField(),
                  const SizedBox(height: 20),
                  _passwordTextField(),
                  const SizedBox(height: 40),
                  _tombolLogin(),
                  const SizedBox(height: 24),
                  _buildForgotPasswordLink(),
                  const SizedBox(height: 16),
                  _buildRegisterLink(), // <-- Cukup satu kali
                  SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _usernameTextField() {
    return TextFormField(
      decoration: const InputDecoration(
        labelText: "Username",
        prefixIcon: Icon(Icons.person_outline),
      ),
      controller: _usernameCtrl,
      validator:
          (value) =>
              (value?.isEmpty ?? true) ? 'Username tidak boleh kosong' : null,
    );
  }

  Widget _passwordTextField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: "Password",
        prefixIcon: const Icon(Icons.lock_outline),
        suffixIcon: IconButton(
          icon: Icon(
            _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
          ),
          onPressed:
              () => setState(() => _isPasswordVisible = !_isPasswordVisible),
        ),
      ),
      obscureText: !_isPasswordVisible,
      controller: _passwordCtrl,
      validator:
          (value) =>
              (value?.isEmpty ?? true) ? 'Password tidak boleh kosong' : null,
    );
  }

  Widget _tombolLogin() {
    return ElevatedButton(
      onPressed: _isLoading ? null : _submitLogin,
      child:
          _isLoading
              ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(),
              )
              : const Text("LOGIN"),
    );
  }

  Widget _buildRegisterLink() {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap:
          () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const RegisterPage()),
          ),
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          text: 'Belum punya akun? ',
          style: theme.textTheme.bodyMedium,
          children: <TextSpan>[
            TextSpan(
              text: 'Daftar di sini',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildForgotPasswordLink() {
    return GestureDetector(
      onTap: () {
        // Navigasi ke halaman lupa password yang akan kita buat
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ForgotPasswordPage()),
        );
      },
      child: Text(
        "Lupa Password?",
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Theme.of(context).colorScheme.primary,
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }

  Future<void> _submitLogin() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      try {
        // === PERBAIKAN DI SINI: TAMBAHKAN .trim() ===
        User? user = await LoginService().login(
          _usernameCtrl.text.trim(),
          _passwordCtrl.text.trim(),
        );

        if (mounted) {
          if (user != null) {
            await UserInfo().login(user);
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const Beranda()),
            );
          } else {
            _showErrorDialog("Username atau Password Tidak Valid");
          }
        }
      } catch (e) {
        if (mounted) _showErrorDialog("Terjadi kesalahan: ${e.toString()}");
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text("Login Gagal"),
            content: Text(message),
            actions: [
              TextButton(
                child: const Text("OK"),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
    );
  }
}
