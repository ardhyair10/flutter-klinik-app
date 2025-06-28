class Artikel {
  final int id;
  final String judul;
  final String? konten;
  final String? gambarUrl; // Pastikan ini ada

  Artikel({
    required this.id,
    required this.judul,
    this.konten,
    this.gambarUrl, // Pastikan ini ada
  });

  factory Artikel.fromJson(Map<String, dynamic> json) {
    return Artikel(
      id: int.parse(json['id'].toString()),
      judul: json['judul'],
      konten: json['konten'],
      gambarUrl: json['gambar_url'], // Pastikan ini ada
    );
  }
}
