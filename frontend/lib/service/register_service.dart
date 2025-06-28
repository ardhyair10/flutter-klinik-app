// lib/service/register_service.dart

import '../helpers/api_client.dart';

class RegisterService {
  // --- FUNGSI INI DIPERBARUI ---
  Future<bool> requestOtp({
    required String namaDepan,
    String? namaBelakang,
    required String jenisKelamin,
    String? ttl, // <-- 1. TAMBAHKAN PARAMETER 'ttl' DI SINI (nullable)
    required String username,
    required String email,
    required String password,
  }) async {
    final body = {
      "nama_depan": namaDepan,
      "nama_belakang": namaBelakang,
      "jenis_kelamin": jenisKelamin,
      "ttl": ttl, // <-- 2. TAMBAHKAN 'ttl' KE BODY REQUEST
      "username": username,
      "email": email,
      "password": password,
    };

    // Panggil API untuk meminta OTP
    final response = await ApiClient().post('register/request-otp', body);

    return response.statusCode == 200;
  }

  // Fungsi verifyOtp tidak perlu diubah
  Future<bool> verifyOtp({required String email, required String otp}) async {
    final body = {"email": email, "otp": otp};
    final response = await ApiClient().post('register/verify-otp', body);
    return response.statusCode == 201;
  }
}
