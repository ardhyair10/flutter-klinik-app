import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:klinik_app/model/resep_obat.dart';
import 'package:klinik_app/service/resep_obat_service.dart';

class ResepObatPage extends StatefulWidget {
  const ResepObatPage({super.key});

  @override
  State<ResepObatPage> createState() => _ResepObatPageState();
}

class _ResepObatPageState extends State<ResepObatPage> {
  late Future<List<ResepObat>> _resepObatFuture;

  @override
  void initState() {
    super.initState();
    _resepObatFuture = ResepObatService().getResepObat();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text("Riwayat Resep Obat")),
      body: FutureBuilder<List<ResepObat>>(
        future: _resepObatFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Tidak ada riwayat resep obat."));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              ResepObat resep = snapshot.data![index];
              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                child: ExpansionTile(
                  leading: Icon(
                    Icons.medication_liquid,
                    color: theme.colorScheme.primary,
                  ),
                  title: Text(
                    "Resep dari ${resep.namaPoli}",
                    style: theme.textTheme.titleMedium,
                  ),
                  subtitle: Text(
                    DateFormat(
                      'EEEE, dd MMMM yyyy',
                      'id_ID',
                    ).format(resep.tanggalResep),
                  ),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Diberikan oleh: ${resep.namaDokter}",
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                          const Divider(height: 20),
                          Text(
                            "Detail Obat:",
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          // Menampilkan detail obat dengan format yang lebih baik
                          ...resep.detailObat
                              .split('\n')
                              .map(
                                (obat) => Padding(
                                  padding: const EdgeInsets.only(
                                    left: 8.0,
                                    bottom: 4.0,
                                  ),
                                  child: Text(
                                    "• $obat",
                                    style: theme.textTheme.bodyMedium,
                                  ),
                                ),
                              ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
