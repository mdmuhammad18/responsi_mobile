import 'package:flutter/material.dart';

/// Tampilan saat daftar kosong atau terjadi error.
class EmptyState extends StatelessWidget {
  /// Pesan utama.
  final String message;

  /// Ikon.
  final IconData icon;

  /// Membuat [EmptyState].
  const EmptyState({
    super.key,
    this.message = 'Belum ada catatan.\nTekan + untuk menambah.',
    this.icon = Icons.note_alt_outlined,
  });

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 72, color: Colors.grey),
          const SizedBox(height: 12),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.grey, fontSize: 16),
          ),
        ],
      ),
    ),
  );
}
