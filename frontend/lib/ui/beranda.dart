import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:klinik_app/helpers/user_info.dart';
import 'package:klinik_app/model/janji_temu.dart';
import 'package:klinik_app/model/user.dart';
import 'package:klinik_app/model/artikel.dart';
import 'package:klinik_app/service/janji_temu_service.dart';
import 'package:klinik_app/service/artikel_service.dart';
import 'package:klinik_app/ui/poli_page.dart';
import '../widget/sidebar.dart';

// Import semua halaman tujuan
import 'riwayat_page.dart';
import 'resep_obat_page.dart';
import 'lokasi_page.dart';
import 'buat_janji_page.dart';
import 'artikel_detail_page.dart';

class Beranda extends StatefulWidget {
  const Beranda({super.key});

  @override
  State<Beranda> createState() => _BerandaState();
}

class _BerandaState extends State<Beranda> {
  User? _user;
  JanjiTemu? _janjiTemuBerikutnya;
  // Hilangkan 'late' karena akan kita inisialisasi langsung
  Future<List<Artikel>>? _artikelFuture;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('id_ID', null);

    // Langsung panggil service di initState dan masukkan ke Future
    // Ini akan memperbaiki error LateInitializationError
    _artikelFuture = ArtikelService().listArtikel();

    _loadData();
  }

  Future<void> _loadData() async {
    // Tidak perlu lagi memanggil setState untuk _isLoading di awal
    final user = await UserInfo().getUser();
    final janjiTemu = await JanjiTemuService().getNextJanjiTemu();

    // Saat refresh, kita panggil lagi service artikel
    final artikelFuture = ArtikelService().listArtikel();

    if (mounted) {
      setState(() {
        _user = user;
        _janjiTemuBerikutnya = janjiTemu;
        _artikelFuture = artikelFuture;
        _isLoading = false; // Matikan loading utama setelah semua data siap
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // ... (build method Anda tetap sama)
    final theme = Theme.of(context);
    return Scaffold(
      drawer: Sidebar(),
      appBar: AppBar(title: const Text("Beranda")),
      body: RefreshIndicator(
        onRefresh: _loadData,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            _buildWelcomeHeader(theme, _user),
            const SizedBox(height: 20),
            _buildJadwalJanjiTemu(theme, _janjiTemuBerikutnya, _isLoading),
            const SizedBox(height: 20),
            _buildMenuCepat(context, theme),
            const SizedBox(height: 20),
            _buildArtikelKesehatan(theme),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const BuatJanjiPage()),
          );
        },
        child: const Icon(Icons.add),
        tooltip: 'Buat Janji Temu',
      ),
    );
  }

  // ... (Semua fungsi _build... Anda tetap sama persis seperti sebelumnya)
  // ...
  Widget _buildWelcomeHeader(ThemeData theme, User? user) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Selamat Datang,", style: theme.textTheme.displaySmall),
        Text(
          user?.namaLengkap ?? "Pengguna...",
          style: theme.textTheme.headlineMedium,
        ),
      ],
    );
  }

  Widget _buildJadwalJanjiTemu(
    ThemeData theme,
    JanjiTemu? janji,
    bool isLoading,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Janji Temu Berikutnya", style: theme.textTheme.titleLarge),
            const SizedBox(height: 16),
            if (isLoading)
              const Center(child: CircularProgressIndicator())
            else if (janji == null)
              const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 20.0),
                  child: Text("Tidak ada janji temu terdekat."),
                ),
              )
            else
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    leading: Icon(
                      Icons.person_pin_circle_outlined,
                      color: theme.primaryColor,
                      size: 40,
                    ),
                    title: Text(
                      janji.namaDokter ?? 'Dokter',
                      style: theme.textTheme.titleMedium,
                    ),
                    subtitle: Text(
                      janji.namaPoli ?? 'Poli',
                      style: theme.textTheme.bodyMedium,
                    ),
                    contentPadding: EdgeInsets.zero,
                  ),
                  const Divider(),
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        size: 16,
                        color: theme.textTheme.bodyMedium?.color,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        DateFormat(
                          'EEEE, dd MMMM yyyy',
                          'id_ID',
                        ).format(janji.tanggal),
                        style: theme.textTheme.bodyMedium,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 16,
                        color: theme.textTheme.bodyMedium?.color,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        janji.waktu.format(context),
                        style: theme.textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuCepat(BuildContext context, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Akses Cepat", style: theme.textTheme.titleLarge),
        const SizedBox(height: 10),
        GridView.count(
          crossAxisCount: 4,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          children: [
            _buildMenuItem(
              context,
              Icons.local_hospital,
              "Poli",
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const PoliPage()),
              ),
            ),
            _buildMenuItem(
              context,
              Icons.history,
              "Riwayat",
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const RiwayatPage()),
              ),
            ),
            _buildMenuItem(
              context,
              Icons.medication,
              "Resep Obat",
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ResepObatPage()),
              ),
            ),
            _buildMenuItem(
              context,
              Icons.location_on,
              "Lokasi",
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LokasiPage()),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMenuItem(
    BuildContext context,
    IconData icon,
    String label,
    VoidCallback onTap,
  ) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Card(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 30, color: theme.primaryColor),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: theme.textTheme.labelSmall,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildArtikelKesehatan(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Info Kesehatan", style: theme.textTheme.titleLarge),
        const SizedBox(height: 10),
        FutureBuilder<List<Artikel>>(
          future: _artikelFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Card(
                child: Center(
                  heightFactor: 3,
                  child: CircularProgressIndicator(),
                ),
              );
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Card(
                child: ListTile(title: Text("Tidak ada artikel.")),
              );
            }
            return Card(
              child: Column(
                children:
                    snapshot.data!.take(2).map((artikel) {
                      final tile = ListTile(
                        leading: Icon(
                          Icons.article_outlined,
                          color: theme.primaryColor,
                        ),
                        title: Text(
                          artikel.judul,
                          style: theme.textTheme.titleMedium,
                        ),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) =>
                                      ArtikelDetailPage(artikel: artikel),
                            ),
                          );
                        },
                      );
                      // Tambahkan divider jika bukan item terakhir
                      if (snapshot.data!.take(2).last != artikel) {
                        return Column(
                          children: [
                            tile,
                            const Divider(height: 1, indent: 16, endIndent: 16),
                          ],
                        );
                      }
                      return tile;
                    }).toList(),
              ),
            );
          },
        ),
      ],
    );
  }
}
