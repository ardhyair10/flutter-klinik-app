import 'package:flutter/material.dart';
import 'package:klinik_app/model/user.dart';
// Nanti kita akan butuh service
// import '../service/user_service.dart';

class UbahProfilPage extends StatefulWidget {
  final User user;
  const UbahProfilPage({super.key, required this.user});

  @override
  State<UbahProfilPage> createState() => _UbahProfilPageState();
}

class _UbahProfilPageState extends State<UbahProfilPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _namaDepanCtrl;
  late final TextEditingController _namaBelakangCtrl;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Isi controller dengan data user saat ini
    _namaDepanCtrl = TextEditingController(text: widget.user.namaDepan);
    _namaBelakangCtrl = TextEditingController(text: widget.user.namaBelakang);
  }

  @override
  void dispose() {
    _namaDepanCtrl.dispose();
    _namaBelakangCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Ubah Profil")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _namaDepanCtrl,
                decoration: const InputDecoration(labelText: "Nama Depan"),
                validator:
                    (value) =>
                        (value?.isEmpty ?? true)
                            ? 'Nama Depan tidak boleh kosong'
                            : null,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _namaBelakangCtrl,
                decoration: const InputDecoration(
                  labelText: "Nama Belakang (Opsional)",
                ),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: _isLoading ? null : _submit,
                child:
                    _isLoading
                        ? const CircularProgressIndicator()
                        : const Text("SIMPAN PERUBAHAN"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      // LOGIKA UNTUK MEMANGGIL API UPDATE AKAN DITARUH DI SINI
      // Untuk sekarang, kita buat dummy-nya dulu
      setState(() => _isLoading = true);
      print("Data yang akan diupdate:");
      print("Nama Depan: ${_namaDepanCtrl.text}");
      print("Nama Belakang: ${_namaBelakangCtrl.text}");

      // Pura-pura berhasil lalu kembali
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) {
          setState(() => _isLoading = false);
          Navigator.pop(context); // Kembali ke halaman profil
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Profil berhasil diperbarui (Simulasi)'),
            ),
          );
        }
      });
    }
  }
}
