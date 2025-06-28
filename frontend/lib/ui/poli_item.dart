// lib/ui/poli_item.dart

import 'package:flutter/material.dart';
import '../model/poli.dart';

class PoliItem extends StatelessWidget {
  final Poli poli;
  final VoidCallback
  onTap; // <-- 1. Tambahkan parameter untuk menerima fungsi onTap

  const PoliItem({
    super.key,
    required this.poli,
    required this.onTap, // <-- 2. Jadikan wajib di constructor
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Gunakan GestureDetector atau InkWell untuk menangani klik
    return GestureDetector(
      onTap: onTap, // <-- 3. Gunakan fungsi onTap yang dikirim dari luar
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListTile(
            leading: Icon(
              Icons.local_hospital,
              color: theme.colorScheme.primary,
              size: 40,
            ),
            title: Text(poli.namaPoli, style: theme.textTheme.titleMedium),
            trailing: const Icon(Icons.chevron_right),
          ),
        ),
      ),
    );
  }
}
