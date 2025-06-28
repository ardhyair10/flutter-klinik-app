// lib/service/auth_service.dart

import '../helpers/api_client.dart';
import 'package:klinik_app/model/user.dart';

class AuthService {
  // Fungsi untuk mengirim permintaan reset password
  Future<bool> requestPasswordReset(String email) async {
    try {
      print("[AuthService] Meminta reset password untuk: $email");
      final body = {"email": email};
      final response = await ApiClient().post('forgot-password', body);
      print(
        "[AuthService] Respon dari forgot-password: ${response.statusCode}",
      );
      return response.statusCode == 200;
    } catch (e) {
      print(">>> KESALAHAN di requestPasswordReset: $e");
      return false;
    }
  }

  // Fungsi untuk verifikasi OTP dan set password baru
  Future<bool> resetPassword({
    required String email,
    required String otp,
    required String newPassword,
  }) async {
    try {
      print("[AuthService] Memulai proses resetPassword untuk email: $email");
      final body = {"email": email, "otp": otp, "newPassword": newPassword};
      final response = await ApiClient().post('reset-password', body);
      print("[AuthService] Respon dari reset-password: ${response.statusCode}");
      return response.statusCode == 200;
    } catch (e) {
      print(">>> KESALAHAN KRITIS DI AUTHSERVICE SAAT RESET PASSWORD: $e");
      return false;
    }
  }

  Future<User?> getMyProfile() async {
    try {
      final response = await ApiClient().get('/me');
      if (response.statusCode == 200) {
        // Backend langsung mengembalikan objek user, tidak dibungkus 'user' lagi
        return User.fromJson(response.data);
      }
    } catch (e) {
      print("Error mengambil profil: $e");
      return null;
    }
    return null;
  }
}
