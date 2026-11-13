import 'package:flutter/material.dart';

import '../models/student.dart';
import '../providers/app_provider.dart';
import '../utils/validators.dart';
import '../widgets/profile_card.dart';

/// Layar profil mahasiswa dengan tombol edit.
class ProfileScreen extends StatelessWidget {
  /// Membuat [ProfileScreen].
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = AppProvider.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Profil Mahasiswa')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ProfileCard(student: app.student),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  icon: const Icon(Icons.edit),
                  label: const Text('Edit Profil'),
                  onPressed: () async {
                    final result = await showDialog<Student>(
                      context: context,
                      builder: (_) => _EditDialog(student: app.student),
                    );
                    if (result != null) {
                      await app.updateStudent(result);
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Profil diperbarui')),
                        );
                      }
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EditDialog extends StatefulWidget {
  final Student student;
  const _EditDialog({required this.student});

  @override
  State<_EditDialog> createState() => _EditDialogState();
}

class _EditDialogState extends State<_EditDialog> {
  final _key = GlobalKey<FormState>();
  late final _name = TextEditingController(text: widget.student.name);
  late final _nim = TextEditingController(text: widget.student.nim);
  late final _prodi = TextEditingController(text: widget.student.programStudi);
  late final _email = TextEditingController(text: widget.student.email);

  @override
  void dispose() {
    _name.dispose();
    _nim.dispose();
    _prodi.dispose();
    _email.dispose();
    super.dispose();
  }

  Widget _field(
    TextEditingController c,
    String label,
    String? Function(String?) v, [
    TextInputType? type,
  ]) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: TextFormField(
      controller: c,
      keyboardType: type,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      validator: v,
    ),
  );

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: const Text('Edit Profil'),
    content: Form(
      key: _key,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _field(
              _name,
              'Nama',
              (v) => Validators.validateRequired(v, 'Nama'),
            ),
            _field(
              _nim,
              'NIM',
              (v) => Validators.validateRequired(v, 'NIM'),
              TextInputType.number,
            ),
            _field(
              _prodi,
              'Program Studi',
              (v) => Validators.validateRequired(v, 'Program studi'),
            ),
            _field(
              _email,
              'Email',
              Validators.validateEmail,
              TextInputType.emailAddress,
            ),
          ],
        ),
      ),
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: const Text('Batal'),
      ),
      FilledButton(
        onPressed: () {
          if (!_key.currentState!.validate()) return;
          Navigator.pop(
            context,
            Student(
              name: Validators.sanitize(_name.text),
              nim: Validators.sanitize(_nim.text),
              programStudi: Validators.sanitize(_prodi.text),
              email: Validators.sanitize(_email.text),
            ),
          );
        },
        child: const Text('Simpan'),
      ),
    ],
  );
}
