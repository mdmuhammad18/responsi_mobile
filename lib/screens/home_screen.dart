import 'package:flutter/material.dart';

import '../models/note.dart';
import '../providers/app_provider.dart';
import '../widgets/empty_state.dart';
import '../widgets/note_card.dart';
import 'note_form_screen.dart';
import 'profile_screen.dart';
import 'users_screen.dart';

/// Layar utama: profil singkat + daftar catatan.
class HomeScreen extends StatelessWidget {
  /// Membuat [HomeScreen].
  const HomeScreen({super.key});

  Future<void> _confirmDelete(BuildContext context, Note note) async {
    final app = AppProvider.of(context);
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hapus Catatan'),
        content: Text('Yakin ingin menghapus "${note.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
    if (ok == true) {
      await app.deleteNote(note.id);
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Catatan dihapus')));
      }
    }
  }

  Widget _body(BuildContext context, AppProvider app) {
    if (app.isLoading) return const Center(child: CircularProgressIndicator());
    if (app.error != null) {
      return EmptyState(icon: Icons.error_outline, message: app.error!);
    }
    if (app.notes.isEmpty) return const EmptyState();
    return ListView.builder(
      itemCount: app.notes.length,
      itemBuilder: (_, i) => NoteCard(
        note: app.notes[i],
        onDelete: () => _confirmDelete(context, app.notes[i]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final app = AppProvider.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Catatan Kuliah'),
        actions: [
          IconButton(
            icon: const Icon(Icons.cloud_download_outlined),
            tooltip: 'Data API',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const UsersScreen()),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.person),
            tooltip: 'Profil',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ProfileScreen()),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            color: Theme.of(context).colorScheme.primaryContainer,
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                CircleAvatar(child: Text(app.student.initials)),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      app.student.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text('NIM: ${app.student.nim}'),
                  ],
                ),
              ],
            ),
          ),
          Expanded(child: _body(context, app)),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final saved = await Navigator.push<bool>(
            context,
            MaterialPageRoute(builder: (_) => const NoteFormScreen()),
          );
          if (saved == true && context.mounted) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text('Catatan tersimpan')));
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
