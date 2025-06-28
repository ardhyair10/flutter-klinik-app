import 'package:flutter/material.dart';
import 'package:klinik_app/model/poli.dart';
import 'package:klinik_app/service/poli_service.dart';
import 'package:klinik_app/ui/poli_page.dart';

class PoliForm extends StatefulWidget {
  final Poli? poli;

  // Menggunakan super parameter untuk konstruktor yang lebih modern
  const PoliForm({super.key, this.poli});

  @override
  State<PoliForm> createState() => _PoliFormState();
}

class _PoliFormState extends State<PoliForm> {
  final _formKey = GlobalKey<FormState>();
  final _namaPoliCtrl = TextEditingController();
  // Tambahkan controller untuk deskripsi
  final _deskripsiPoliCtrl = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Jika ada data poli yang dikirim (mode Ubah), isi semua field
    if (widget.poli != null) {
      _namaPoliCtrl.text = widget.poli!.namaPoli;
      _deskripsiPoliCtrl.text = widget.poli!.deskripsiPoli ?? '';
    }
  }

  @override
  void dispose() {
    _namaPoliCtrl.dispose();
    _deskripsiPoliCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.poli == null ? "Tambah Poli" : "Ubah Poli"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildNamaPoliField(),
              const SizedBox(height: 20),
              _buildDeskripsiPoliField(), // Tambahkan field deskripsi
              const SizedBox(height: 40),
              _buildTombolSimpan(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNamaPoliField() {
    return TextFormField(
      decoration: const InputDecoration(labelText: "Nama Poli"),
      controller: _namaPoliCtrl,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Nama Poli tidak boleh kosong';
        }
        return null;
      },
    );
  }

  Widget _buildDeskripsiPoliField() {
    return TextFormField(
      decoration: const InputDecoration(
        labelText: "Deskripsi Poli",
        alignLabelWithHint: true,
      ),
      controller: _deskripsiPoliCtrl,
      maxLines: 3,
      // Deskripsi bisa jadi opsional, jadi tidak perlu validator
    );
  }

  Widget _buildTombolSimpan() {
    return ElevatedButton(
      onPressed: _isLoading ? null : _submit,
      child:
          _isLoading
              ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(),
              )
              : const Text("Simpan"),
    );
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      // --- LOGIKA PEMBUATAN OBJEK DIPERBAIKI ---
      Poli poliData = Poli(
        id:
            widget
                .poli
                ?.id, // Gunakan id yang ada jika mode ubah, jika tidak maka null
        namaPoli: _namaPoliCtrl.text,
        deskripsiPoli: _deskripsiPoliCtrl.text,
      );

      try {
        Poli? result;
        if (widget.poli == null) {
          // Mode Tambah: Panggil createPoli
          result = await PoliService().createPoli(poliData);
        } else {
          // Mode Ubah: Panggil updatePoli
          result = await PoliService().updatePoli(poliData);
        }

        if (mounted) {
          if (result != null) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const PoliPage()),
              (route) => false,
            );
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Data Poli berhasil disimpan!'),
                backgroundColor: Colors.green,
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Gagal menyimpan data'),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Terjadi kesalahan: ${e.toString()}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }
}
