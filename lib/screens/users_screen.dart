import 'package:flutter/material.dart';

import '../services/api_service.dart';
import '../widgets/empty_state.dart';

/// Menampilkan data HTTP GET (/users) di ListView.
class UsersScreen extends StatefulWidget {
  /// Membuat [UsersScreen].
  const UsersScreen({super.key});

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  late Future<List<Map<String, dynamic>>> _future = ApiService().fetchUsers();

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Data API Publik')),
    body: FutureBuilder<List<Map<String, dynamic>>>(
      future: _future,
      builder: (context, snap) {
        if (snap.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snap.hasError) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                EmptyState(
                  icon: Icons.error_outline,
                  message: snap.error.toString().replaceFirst(
                    'Exception: ',
                    '',
                  ),
                ),
                FilledButton(
                  onPressed: () =>
                      setState(() => _future = ApiService().fetchUsers()),
                  child: const Text('Coba Lagi'),
                ),
              ],
            ),
          );
        }
        final users = snap.data ?? [];
        return ListView.builder(
          itemCount: users.length,
          itemBuilder: (_, i) => ListTile(
            leading: CircleAvatar(child: Text('${users[i]['id']}')),
            title: Text('${users[i]['name']}'),
            subtitle: Text('${users[i]['email']}'),
          ),
        );
      },
    ),
  );
}
