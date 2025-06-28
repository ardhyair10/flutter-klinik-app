class ResepObat {
  final int id;
  final DateTime tanggalResep;
  final String detailObat;
  final String? namaPoli;
  final String? namaDokter;

  ResepObat({
    required this.id,
    required this.tanggalResep,
    required this.detailObat,
    this.namaPoli,
    this.namaDokter,
  });

  factory ResepObat.fromJson(Map<String, dynamic> json) {
    return ResepObat(
      id: int.parse(json['id'].toString()),
      tanggalResep: DateTime.parse(json['tanggal_resep']),
      detailObat: json['detail_obat'],
      namaPoli: json['nama_poli'],
      namaDokter: json['nama_dokter'],
    );
  }
}
