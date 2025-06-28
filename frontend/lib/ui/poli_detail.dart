import 'package:flutter/material.dart';
import 'package:klinik_app/ui/poli_update_form.dart';
import '../model/poli.dart';
import '../service/poli_service.dart';
import 'poli_page.dart';

class PoliDetail extends StatefulWidget {
  final Poli poli;

  const PoliDetail({super.key, required this.poli});

  @override
  State<PoliDetail> createState() => _PoliDetailState();
}

class _PoliDetailState extends State<PoliDetail> {
  bool _isLoading = false; // State untuk loading hapus

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // Ambil tema

    return Scaffold(
      appBar: AppBar(title: const Text("Detail Poli")),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.poli.namaPoli,
              // Gunakan gaya teks dari tema
              style: theme.textTheme.displaySmall,
            ),
            const SizedBox(height: 24),
            Text("Deskripsi:", style: theme.textTheme.titleLarge),
            const SizedBox(height: 8),
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  // Tampilkan deskripsi, atau pesan default jika null/kosong
                  widget.poli.deskripsiPoli ?? 'Tidak ada deskripsi.',
                  style: theme.textTheme.bodyLarge,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [_tombolUbah(theme), _tombolHapus(theme)],
            ),
          ],
        ),
      ),
    );
  }

  Widget _tombolUbah(ThemeData theme) {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          // Gunakan push agar bisa kembali
          context,
          MaterialPageRoute(
            builder: (context) => PoliUpdateForm(poli: widget.poli),
          ),
        );
      },
      // Tombol tidak perlu style manual karena sudah diatur di app_theme.dart
      child: const Text("Ubah"),
    );
  }

  Widget _tombolHapus(ThemeData theme) {
    return ElevatedButton(
      onPressed: _isLoading ? null : _konfirmasiHapus,
      // Ganti warna tombol hapus menggunakan styleFrom
      style: ElevatedButton.styleFrom(
        backgroundColor: theme.colorScheme.error,
        foregroundColor: theme.colorScheme.onError,
      ),
      child:
          _isLoading
              ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(color: Colors.white),
              )
              : const Text("Hapus"),
    );
  }

  void _konfirmasiHapus() {
    final theme = Theme.of(context);
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text("Konfirmasi Hapus"),
            content: const Text("Apakah Anda yakin ingin menghapus data ini?"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Batal"),
              ),
              ElevatedButton(
                onPressed: _prosesHapus, // Panggil fungsi hapus
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.error,
                  foregroundColor: theme.colorScheme.onError,
                ),
                child: const Text("YA, Hapus"),
              ),
            ],
          ),
    );
  }

  void _prosesHapus() async {
    setState(() => _isLoading = true);
    Navigator.of(context).pop(); // Tutup dialog konfirmasi

    try {
      bool success = await PoliService().deletePoli(widget.poli);
      if (mounted) {
        if (success) {
          // Kembali ke halaman daftar dan hapus semua halaman di atasnya
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const PoliPage()),
            (route) => false,
          );
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Data berhasil dihapus'),
              backgroundColor: Colors.green,
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Gagal menghapus data'),
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
