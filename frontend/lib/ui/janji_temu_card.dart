import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:klinik_app/model/janji_temu.dart';

class JanjiTemuCard extends StatelessWidget {
  final JanjiTemu janji;
  const JanjiTemuCard({super.key, required this.janji});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    janji.namaPoli ?? 'Poli Tidak Diketahui',
                    style: theme.textTheme.titleLarge,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    janji.status,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const Divider(height: 20),
            _buildInfoRow(
              theme,
              Icons.person_outline,
              janji.namaDokter ?? 'Dokter tidak tersedia',
            ),
            const SizedBox(height: 8),
            _buildInfoRow(
              theme,
              Icons.calendar_today_outlined,
              DateFormat('EEEE, dd MMMM yyyy', 'id_ID').format(janji.tanggal),
            ),
            const SizedBox(height: 8),
            _buildInfoRow(
              theme,
              Icons.access_time_outlined,
              janji.waktu.format(context),
            ),
            const SizedBox(height: 16),
            Text(
              'Keluhan:',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(janji.keluhan, style: theme.textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(ThemeData theme, IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: theme.textTheme.bodyMedium?.color),
        const SizedBox(width: 12),
        Expanded(child: Text(text, style: theme.textTheme.bodyMedium)),
      ],
    );
  }
}
