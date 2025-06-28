// lib/service/login_service.dart

import 'dart:convert';
import '../helpers/api_client.dart';
import '../model/user.dart';

class LoginService {
  Future<User?> login(String username, String password) async {
    try {
      final body = {"username": username, "password": password};
      final response = await ApiClient().post('login', body);

      // --- TAMBAHKAN LOG UNTUK DEBUGGING ---
      print("[LoginService] Status Code: ${response.statusCode}");
      // Mencetak data mentah yang diterima dari server
      print("[LoginService] Response Data: ${jsonEncode(response.data)}");
      // ------------------------------------

      if (response.statusCode == 200) {
        // Cek apakah data 'user' ada di dalam respon
        if (response.data != null && response.data['user'] != null) {
          // Jika semua aman, parse user
          final user = User.fromJson(response.data['user']);
          print("[LoginService] User berhasil diparsing: ${user.namaLengkap}");
          return user;
        } else {
          // Status 200, tapi response.data null atau tidak ada key 'user'
          print(
            "[LoginService] Status 200, TAPI response.data atau response.data['user'] null atau tidak ditemukan.",
          );
          print(
            "[LoginService] Pastikan backend mengirimkan JSON dengan format {'user': {...}}.",
          );
          // Akan jatuh ke return null di akhir
        }
      } else {
        // Status code bukan 200, misal 401, 400, 500 dll.
        print("[LoginService] Status code BUKAN 200: ${response.statusCode}.");
        print(
          "[LoginService] Response error dari server (jika ada): ${response.data}",
        );
        // Akan jatuh ke return null di akhir
      }
    } catch (e) {
      print("[LoginService] Exception saat login: $e");
      // Akan jatuh ke return null di akhir
    }
    // Jika salah satu kondisi di atas tidak terpenuhi atau terjadi exception, fungsi akan mengembalikan null.
    return null;
  }
}
