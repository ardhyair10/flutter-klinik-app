import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/user.dart';

class UserInfo {
  // Definisikan kunci yang akan digunakan secara konsisten
  static const String _userKey = 'user';

  // Menyimpan data user setelah login berhasil
  Future<void> login(User user) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    String userJson = jsonEncode(user.toJson());
    await pref.setString(_userKey, userJson);
  }

  // Mengambil data user yang sedang login
  Future<User?> getUser() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    String? userJson = pref.getString(_userKey);
    if (userJson == null) {
      return null;
    }
    return User.fromJson(jsonDecode(userJson));
  }

  // Menghapus data user saat logout
  Future<void> logout() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    // Log untuk debugging
    print("[UserInfo] Menghapus data sesi untuk kunci: $_userKey");
    // Hanya hapus data user, tidak semua data di SharedPreferences
    await pref.remove(_userKey);
  }
}
