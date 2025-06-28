// lib/main.dart

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

import 'helpers/user_info.dart';
import 'model/user.dart';
import 'ui/beranda.dart';
import 'ui/login.dart'; // <-- PASTIKAN BARIS INI ADA
import 'providers/theme_provider.dart';
import 'service/navigation_service.dart'; // Jika Anda menggunakannya
import 'theme/app_theme.dart';

// ... sisa kode main.dart Anda ...

Future<void> main() async {
  // ... (kode main() Anda tidak berubah)
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await dotenv.load(fileName: ".env");
    final User? user = await UserInfo().getUser();
    runApp(
      ChangeNotifierProvider(
        create: (context) => ThemeProvider(),
        child: MyApp(user: user),
      ),
    );
  } catch (e, stack) {
    // ...
  }
}

class MyApp extends StatelessWidget {
  final User? user;
  const MyApp({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();

    return MaterialApp(
      // === 2. PASANG KUNCI DI SINI ===
      navigatorKey: NavigationService.navigatorKey,

      debugShowCheckedModeBanner: false,
      title: 'Klinik APP',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkFuturisticTheme,
      themeMode: themeProvider.themeMode,
      home: user == null ? const Login() : const Beranda(),
    );
  }
}
