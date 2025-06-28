import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../helpers/user_info.dart';
import '../model/user.dart';
import '../providers/theme_provider.dart';
import '../service/navigation_service.dart';
import '../ui/beranda.dart';
import '../ui/poli_page.dart';
import '../ui/login.dart';
import '../ui/profil_page.dart';
import '../ui/riwayat_page.dart';

class Sidebar extends StatefulWidget {
  const Sidebar({super.key});

  @override
  State<Sidebar> createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> {
  User? _user;

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    final user = await UserInfo().getUser();
    if (mounted) {
      setState(() {
        _user = user;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final themeProvider = context.watch<ThemeProvider>();

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(
              _user?.namaLengkap ?? "Pengguna",
              style: theme.textTheme.headlineSmall,
            ),
            accountEmail: Text(
              _user?.username ?? "",
              style: theme.textTheme.bodySmall,
            ),
            decoration: BoxDecoration(color: theme.primaryColor),
          ),

          _buildDrawerItem(
            icon: Icons.home,
            title: "Beranda",
            onTap:
                () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const Beranda()),
                ),
          ),

          // Tampilkan menu ini hanya jika user adalah admin
          if (_user?.role == 'admin') ...[
            _buildDrawerItem(
              icon: Icons.local_hospital_outlined,
              title: "Poli",
              onTap:
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const PoliPage()),
                  ),
            ),
            _buildDrawerItem(
              icon: Icons.people_outline,
              title: "Pegawai",
              onTap: () {
                // TODO: Navigasi ke halaman Pegawai
              },
            ),
            _buildDrawerItem(
              icon: Icons.personal_injury_outlined,
              title: "Pasien",
              onTap: () {
                // TODO: Navigasi ke halaman Pasien
              },
            ),
          ],

          _buildDrawerItem(
            icon: Icons.history,
            title: "Riwayat Janji Temu",
            onTap:
                () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const RiwayatPage()),
                ),
          ),

          _buildDrawerItem(
            icon: Icons.person_outline,
            title: "Profil Saya",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfilPage()),
              );
            },
          ),
          SwitchListTile(
            title: Text("Mode Gelap", style: theme.textTheme.titleMedium),
            secondary: Icon(
              themeProvider.themeMode == ThemeMode.dark
                  ? Icons.brightness_7
                  : Icons.brightness_2,
              color: theme.colorScheme.primary,
            ),
            value: themeProvider.themeMode == ThemeMode.dark,
            onChanged: (value) {
              context.read<ThemeProvider>().toggleTheme();
            },
          ),
          const Divider(),
          _buildDrawerItem(
            icon: Icons.logout_rounded,
            title: "Keluar",
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext dialogContext) {
                  return AlertDialog(
                    title: const Text("Konfirmasi Keluar"),
                    content: const Text("Apakah Anda yakin ingin keluar?"),
                    actions: [
                      TextButton(
                        child: const Text("Batal"),
                        onPressed: () => Navigator.of(dialogContext).pop(),
                      ),
                      TextButton(
                        child: Text(
                          "Ya",
                          style: TextStyle(color: theme.colorScheme.error),
                        ),
                        onPressed: () async {
                          Navigator.of(dialogContext).pop();
                          await UserInfo().logout();
                          NavigationService.navigatorKey.currentState
                              ?.pushAndRemoveUntil(
                                MaterialPageRoute(
                                  builder: (context) => const Login(),
                                ),
                                (Route<dynamic> route) => false,
                              );
                        },
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    return ListTile(
      leading: Icon(icon, color: theme.colorScheme.primary.withOpacity(0.8)),
      title: Text(title, style: theme.textTheme.titleMedium),
      onTap: () {
        Navigator.pop(context);
        onTap();
      },
    );
  }
}
