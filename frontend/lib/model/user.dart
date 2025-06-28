// lib/model/user.dart

class User {
  final String? id;
  final String? namaDepan;
  final String? namaBelakang;
  final String? username;
  final String? email;
  final String? role;

  User({
    this.id,
    this.namaDepan,
    this.namaBelakang,
    this.username,
    this.email,
    this.role,
  });

  // Getter yang aman untuk selalu mendapatkan nama lengkap
  String get namaLengkap {
    return '${namaDepan ?? ''} ${namaBelakang ?? ''}'.trim();
  }

  factory User.fromJson(Map<String, dynamic> json) {
    // Logika cerdas untuk menangani berbagai format nama
    String? namaDepanDariJson = json['nama_depan'];
    String? namaBelakangDariJson = json['nama_belakang'];

    // Jika dari backend dikirim 'nama_lengkap', kita pecah jadi nama depan & belakang
    if (namaDepanDariJson == null && json['nama_lengkap'] != null) {
      final namaLengkapParts = (json['nama_lengkap'] as String).split(' ');
      namaDepanDariJson =
          namaLengkapParts.isNotEmpty ? namaLengkapParts.first : '';
      if (namaLengkapParts.length > 1) {
        namaBelakangDariJson = namaLengkapParts.sublist(1).join(' ');
      }
    }

    return User(
      // PERBAIKAN UTAMA: Konversi ID (bisa int/string) menjadi String dengan aman
      id: json['id']?.toString(),
      namaDepan: namaDepanDariJson,
      namaBelakang: namaBelakangDariJson,
      username: json['username'],
      email: json['email'], // Kita tambahkan juga email untuk kelengkapan
      role: json['role'],
    );
  }

  // toJson untuk kelengkapan jika suatu saat dibutuhkan
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama_depan': namaDepan,
      'nama_belakang': namaBelakang,
      'username': username,
      'email': email,
      'role': role,
    };
  }
}
