import 'package:flutter/material.dart';
import 'package:klinik_app/model/artikel.dart';
import 'package:klinik_app/service/artikel_service.dart';

class ArtikelDetailPage extends StatefulWidget {
  final Artikel artikel;
  const ArtikelDetailPage({super.key, required this.artikel});

  @override
  State<ArtikelDetailPage> createState() => _ArtikelDetailPageState();
}

class _ArtikelDetailPageState extends State<ArtikelDetailPage> {
  // Ambil detail artikel lengkap (termasuk konten)
  late Future<Artikel?> _artikelDetailFuture;

  @override
  void initState() {
    super.initState();
    _artikelDetailFuture = ArtikelService().getById(widget.artikel.id);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      // AppBar sekarang hanya menampilkan panah kembali, judul ada di body
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        // Atur warna ikon panah kembali agar kontras dengan gambar
        iconTheme: const IconThemeData(color: Colors.white),
        // Tambahkan efek bayangan pada ikon agar lebih terlihat di atas gambar terang
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.black54, Colors.transparent],
            ),
          ),
        ),
      ),
      // Memastikan AppBar menyatu dengan body
      extendBodyBehindAppBar: true,
      body: FutureBuilder<Artikel?>(
        future: _artikelDetailFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError || !snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text("Gagal memuat detail artikel."));
          }

          final artikelDetail = snapshot.data!;

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Gambar sebagai header
                _buildArticleImage(artikelDetail),

                // Konten teks dengan padding
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        artikelDetail.judul,
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Divider(),
                      const SizedBox(height: 16),
                      Text(
                        artikelDetail.konten ?? 'Konten tidak tersedia.',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontSize: 16,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // Fungsi helper untuk membangun gambar
  Widget _buildArticleImage(Artikel artikelDetail) {
    if (artikelDetail.gambarUrl != null &&
        artikelDetail.gambarUrl!.isNotEmpty) {
      return Image.network(
        artikelDetail.gambarUrl!,
        width: double.infinity,
        height: 280, // Sedikit lebih tinggi
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return const SizedBox(
            height: 280,
            child: Center(child: CircularProgressIndicator()),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return const SizedBox(
            height: 280,
            child: Icon(
              Icons.broken_image_outlined,
              size: 60,
              color: Colors.grey,
            ),
          );
        },
      );
    }
    // Jika tidak ada URL gambar, kembalikan widget kosong yang aman
    return const SizedBox.shrink();
  }
}
