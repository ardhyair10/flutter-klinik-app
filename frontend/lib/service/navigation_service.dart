import 'package:flutter/material.dart';

// Kelas ini hanya untuk menyimpan satu hal: kunci global untuk navigator.
class NavigationService {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();
}
