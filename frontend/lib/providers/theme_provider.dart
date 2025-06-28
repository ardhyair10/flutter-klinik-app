// lib/providers/theme_provider.dart

import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  // Secara default, kita mulai dengan mode terang
  ThemeMode _themeMode = ThemeMode.light;

  // Getter untuk mendapatkan themeMode saat ini
  ThemeMode get themeMode => _themeMode;

  // Fungsi untuk mengubah tema
  void toggleTheme() {
    _themeMode =
        _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;

    // Memberi tahu semua widget yang mendengarkan bahwa ada perubahan
    notifyListeners();
  }
}
