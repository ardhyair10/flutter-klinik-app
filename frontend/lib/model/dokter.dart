// lib/model/dokter.dart

class Dokter {
  final int id;
  final String namaDokter;
  final int poliId;

  Dokter({required this.id, required this.namaDokter, required this.poliId});

  factory Dokter.fromJson(Map<String, dynamic> json) {
    return Dokter(
      // INI ADALAH PERBAIKAN KUNCI:
      // Mengonversi data dari JSON menjadi int dengan aman
      id: int.parse(json['id'].toString()),
      namaDokter: json['nama_dokter'],
      poliId: int.parse(json['poli_id'].toString()),
    );
  }

  // toJson bisa ditambahkan jika perlu
  Map<String, dynamic> toJson() {
    return {'id': id, 'nama_dokter': namaDokter, 'poli_id': poliId};
  }
}
