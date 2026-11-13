import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/note.dart';

/// Kartu satu catatan kuliah.
class NoteCard extends StatelessWidget {
  /// Catatan yang ditampilkan.
  final Note note;

  /// Dipanggil saat tombol hapus ditekan.
  final VoidCallback onDelete;

  /// Membuat [NoteCard].
  const NoteCard({super.key, required this.note, required this.onDelete});

  @override
  Widget build(BuildContext context) => Card(
    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
    child: ListTile(
      title: Text(note.title, maxLines: 1, overflow: TextOverflow.ellipsis),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 4),
          Text(note.content, maxLines: 2, overflow: TextOverflow.ellipsis),
          const SizedBox(height: 6),
          Text(
            DateFormat('dd MMM yyyy, HH:mm').format(note.createdAt),
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
      isThreeLine: true,
      trailing: IconButton(
        icon: const Icon(Icons.delete_outline),
        tooltip: 'Hapus',
        onPressed: onDelete,
      ),
    ),
  );
}
