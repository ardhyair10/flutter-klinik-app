// lib/ui/riwayat_page.dart

import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import '../model/janji_temu.dart';
import '../service/janji_temu_service.dart'; // <-- IMPORT SERVICE
import '../widget/janji_temu_card.dart'; // <-- IMPORT WIDGET CARD

class RiwayatPage extends StatefulWidget {
  const RiwayatPage({super.key});

  @override
  State<RiwayatPage> createState() => _RiwayatPageState();
}

class _RiwayatPageState extends State<RiwayatPage> {
  late Future<List<JanjiTemu>> _riwayatFuture;

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('id_ID', null);
    _riwayatFuture = JanjiTemuService().getRiwayat();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Riwayat Janji Temu")),
      body: FutureBuilder<List<JanjiTemu>>(
        future: _riwayatFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Tidak ada riwayat janji temu."));
          }

          return RefreshIndicator(
            onRefresh: () async {
              setState(() {
                _riwayatFuture = JanjiTemuService().getRiwayat();
              });
            },
            child: ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                // Panggil widget JanjiTemuCard
                return JanjiTemuCard(janji: snapshot.data![index]);
              },
            ),
          );
        },
      ),
    );
  }
}
