import 'package:flutter/material.dart';
import 'package:klinik_app/model/poli.dart';
import 'package:klinik_app/service/poli_service.dart';
import 'package:klinik_app/ui/buat_janji_page.dart'; // <-- Ganti tujuan navigasi
import 'package:klinik_app/ui/poli_item.dart';
import '../widget/sidebar.dart';

class PoliPage extends StatefulWidget {
  const PoliPage({super.key});

  @override
  State<PoliPage> createState() => _PoliPageState();
}

class _PoliPageState extends State<PoliPage> {
  late Future<List<Poli>> _poliListFuture;

  @override
  void initState() {
    super.initState();
    _poliListFuture = PoliService().listData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Sidebar(),
      appBar: AppBar(title: const Text("Pilih Poli")), // Judul diubah
      body: FutureBuilder<List<Poli>>(
        future: _poliListFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Data Poli Kosong"));
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              Poli poli = snapshot.data![index];
              return PoliItem(
                poli: poli,
                onTap: () {
                  // Sekarang PoliItem akan menerima perintah ini
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BuatJanjiPage(poli: poli),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
      // Tombol + (FloatingActionButton) dihapus dari sini
    );
  }
}
