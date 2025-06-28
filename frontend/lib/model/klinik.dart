class Klinik {
  final int id;
  final String namaKlinik;
  final String alamat;
  final double latitude;
  final double longitude;

  Klinik({
    required this.id,
    required this.namaKlinik,
    required this.alamat,
    required this.latitude,
    required this.longitude,
  });

  factory Klinik.fromJson(Map<String, dynamic> json) {
    return Klinik(
      id: int.parse(json['id'].toString()),
      namaKlinik: json['nama_klinik'],
      alamat: json['alamat'],
      latitude: double.parse(json['latitude'].toString()),
      longitude: double.parse(json['longitude'].toString()),
    );
  }
}
