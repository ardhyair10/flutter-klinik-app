// lib/service/janji_temu_service.dart

import 'package:intl/intl.dart';
import 'package:flutter/material.dart'; // Dibutuhkan untuk TimeOfDay
import '../helpers/api_client.dart';
import '../model/janji_temu.dart';

class JanjiTemuService {
  // Fungsi untuk membuat janji temu
  Future<bool> createJanjiTemu({
    required int poliId,
    required int dokterId,
    required DateTime tanggal,
    required TimeOfDay waktu,
    required String keluhan,
  }) async {
    try {
      final formattedDate = DateFormat('yyyy-MM-dd').format(tanggal);
      final formattedTime =
          '${waktu.hour.toString().padLeft(2, '0')}:${waktu.minute.toString().padLeft(2, '0')}:00';
      final body = {
        "poliId": poliId,
        "dokterId": dokterId,
        "tanggal": formattedDate,
        "waktu": formattedTime,
        "keluhan": keluhan,
      };
      print("[JanjiTemuService] Body yang akan dikirim ke API: $body");
      final response = await ApiClient().post('janji-temu', body);
      return response.statusCode == 201;
    } catch (e) {
      print("Error membuat janji temu: $e");
      return false;
    }
  }

  // Fungsi untuk mengambil riwayat janji temu
  Future<List<JanjiTemu>> getRiwayat() async {
    try {
      final response = await ApiClient().get('janji-temu/riwayat');
      final List data = response.data as List;
      List<JanjiTemu> result =
          data.map((json) => JanjiTemu.fromJson(json)).toList();
      return result;
    } catch (e) {
      print("Error mengambil riwayat: $e");
      return [];
    }
  }

  Future<JanjiTemu?> getNextJanjiTemu() async {
    try {
      final response = await ApiClient().get('janji-temu/berikutnya');
      // Jika backend mengembalikan data (bukan null atau kosong), parse datanya
      if (response.statusCode == 200 && response.data != null) {
        return JanjiTemu.fromJson(response.data);
      }
      return null;
    } catch (e) {
      print("Error mengambil janji temu berikutnya: $e");
      return null;
    }
  }
}
