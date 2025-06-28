// lib/model/janji_temu.dart

import 'package:flutter/material.dart';

class JanjiTemu {
  final int id;
  final DateTime tanggal;
  final TimeOfDay waktu;
  final String keluhan;
  final String status;
  final String? namaPoli;
  final String? namaDokter;

  JanjiTemu({
    required this.id,
    required this.tanggal,
    required this.waktu,
    required this.keluhan,
    required this.status,
    this.namaPoli,
    this.namaDokter,
  });

  // --- PASTIKAN FUNGSI INI SAMA PERSIS ---
  factory JanjiTemu.fromJson(Map<String, dynamic> json) {
    // Parsing waktu dari string "HH:mm:ss"
    final timeParts = json['waktu'].split(':');
    final time = TimeOfDay(
      hour: int.parse(timeParts[0]),
      minute: int.parse(timeParts[1]),
    );

    return JanjiTemu(
      // Konversi ID menjadi int dengan aman
      id: int.parse(json['id'].toString()),

      // Parsing tanggal dari string "YYYY-MM-DD"
      tanggal: DateTime.parse(json['tanggal']),
      waktu: time,
      keluhan: json['keluhan'],
      status: json['status'],
      namaPoli: json['nama_poli'],
      namaDokter: json['nama_dokter'],
    );
  }
}
