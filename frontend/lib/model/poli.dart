// lib/model/poli.dart

class Poli {
  int? id; // <-- Dibuat nullable agar bisa kosong saat membuat data baru
  String namaPoli;
  String? deskripsiPoli;

  Poli({this.id, required this.namaPoli, this.deskripsiPoli});

  factory Poli.fromJson(Map<String, dynamic> json) {
    return Poli(
      id: json['id_poli'] as int?, // Dibaca sebagai int nullable
      namaPoli: json['nama_poli'],
      deskripsiPoli: json['deskripsi_poli'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'nama_poli': namaPoli, 'deskripsi_poli': deskripsiPoli};
  }
}
