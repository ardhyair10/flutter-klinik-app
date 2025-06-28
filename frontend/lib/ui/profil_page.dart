import 'package:flutter/material.dart';
import 'package:klinik_app/model/user.dart';
import 'package:klinik_app/service/auth_service.dart';
import 'package:klinik_app/ui/ubah_profil_page.dart'; // <-- PASTIKAN IMPORT INI ADA

class ProfilPage extends StatefulWidget {
  const ProfilPage({super.key});

  @override
  State<ProfilPage> createState() => _ProfilPageState();
}

class _ProfilPageState extends State<ProfilPage> {
  late Future<User?> _userFuture;

  @override
  void initState() {
    super.initState();
    _userFuture = AuthService().getMyProfile();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text("Profil Saya")),
      body: FutureBuilder<User?>(
        future: _userFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError || !snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text("Gagal memuat data profil."));
          }

          final user = snapshot.data!;

          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: theme.colorScheme.primaryContainer,
                        child: Text(
                          (user.namaLengkap.isNotEmpty)
                              ? user.namaLengkap[0].toUpperCase()
                              : 'U',
                          style: theme.textTheme.displayMedium?.copyWith(
                            color: theme.colorScheme.onPrimaryContainer,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        user.namaLengkap,
                        style: theme.textTheme.headlineSmall,
                      ),
                      Text(
                        user.username ?? 'No Username',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Card(
                child: Column(
                  children: [
                    _buildInfoTile(
                      icon: Icons.person_outline,
                      title: "Username",
                      subtitle: user.username ?? 'Tidak ada data',
                    ),
                    const Divider(height: 1, indent: 16, endIndent: 16),
                    _buildInfoTile(
                      icon: Icons.badge_outlined,
                      title: "Role",
                      subtitle:
                          (user.role?.isNotEmpty ?? false)
                              ? user.role!.toUpperCase()
                              : 'USER',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // --- TOMBOL AKSI YANG SUDAH DIPERBAIKI ---
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UbahProfilPage(user: user),
                    ),
                  );
                },
                icon: const Icon(Icons.edit_outlined),
                label: const Text("Ubah Profil"),
              ),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: () {
                  /* TODO: Navigasi ke halaman ubah password */
                },
                icon: const Icon(Icons.lock_outline),
                label: const Text("Ubah Password"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.secondary,
                  foregroundColor: theme.colorScheme.onSecondary,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildInfoTile({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return ListTile(
      leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
      title: Text(title),
      subtitle: Text(subtitle, style: Theme.of(context).textTheme.bodyLarge),
    );
  }
}
