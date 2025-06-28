// lib/service/dokter_service.dart

import '../helpers/api_client.dart';
import '../model/dokter.dart';

class DokterService {
  Future<List<Dokter>> getByPoliId(int poliId) async {
    print("[DokterService] Meminta dokter untuk poli ID: $poliId");
    try {
      final response = await ApiClient().get('dokter/poli/$poliId');
      final List data = response.data as List;

      // --- LOGGING DETAIL ---
      print("[DokterService] Data mentah diterima dari backend:");
      print(data); // Cetak seluruh list data mentah

      // Cetak detail dan tipe data dari item PERTAMA
      if (data.isNotEmpty) {
        print("-------------------------------------------");
        print("[DokterService] Memeriksa item pertama...");
        var firstDoctorData = data[0];
        print("[DokterService] Data item pertama: $firstDoctorData");
        print(
          "[DokterService] Tipe data dari 'id': ${firstDoctorData['id'].runtimeType}",
        );
        print(
          "[DokterService] Tipe data dari 'poli_id': ${firstDoctorData['poli_id'].runtimeType}",
        );
        print("-------------------------------------------");
      }
      // --- AKHIR LOGGING ---

      return data.map((json) => Dokter.fromJson(json)).toList();
    } catch (e) {
      print(">>> ERROR di DokterService > getByPoliId: $e");
      return [];
    }
  }
}
