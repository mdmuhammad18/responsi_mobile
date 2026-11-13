import 'package:flutter/material.dart';

import '../models/student.dart';

/// Kartu profil mahasiswa.
class ProfileCard extends StatelessWidget {
  /// Data mahasiswa yang ditampilkan.
  final Student student;

  /// Membuat [ProfileCard].
  const ProfileCard({super.key, required this.student});

  Widget _row(IconData icon, String label, String value) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Row(
      children: [
        Icon(icon, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
              Text(value, style: const TextStyle(fontSize: 15)),
            ],
          ),
        ),
      ],
    ),
  );

  @override
  Widget build(BuildContext context) => Card(
    margin: const EdgeInsets.all(16),
    child: Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          CircleAvatar(
            radius: 44,
            child: Text(
              student.initials,
              style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            student.name,
            style: Theme.of(context).textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
          const Divider(height: 28),
          _row(Icons.badge_outlined, 'NIM', student.nim),
          _row(Icons.school_outlined, 'Program Studi', student.programStudi),
          _row(Icons.email_outlined, 'Email', student.email),
        ],
      ),
    ),
  );
}
