import 'package:flutter/material.dart';

import '../models/note.dart';
import '../models/student.dart';
import '../repositories/note_repository.dart';

/// InheritedWidget penyedia state aplikasi ke seluruh subtree.
class AppProvider extends InheritedWidget {
  /// Data profil saat ini.
  final Student student;

  /// Daftar catatan.
  final List<Note> notes;

  /// Status memuat data awal.
  final bool isLoading;

  /// Pesan error (jika ada).
  final String? error;

  /// Memperbarui profil.
  final Future<void> Function(Student) updateStudent;

  /// Menambah catatan.
  final Future<void> Function(Note) addNote;

  /// Menghapus catatan berdasarkan id.
  final Future<void> Function(String) deleteNote;

  /// Membuat [AppProvider].
  const AppProvider({
    super.key,
    required this.student,
    required this.notes,
    required this.isLoading,
    required this.error,
    required this.updateStudent,
    required this.addNote,
    required this.deleteNote,
    required super.child,
  });

  /// Mengambil provider terdekat dari [context].
  static AppProvider of(BuildContext context) {
    final p = context.dependOnInheritedWidgetOfExactType<AppProvider>();
    assert(p != null, 'AppProvider tidak ditemukan di widget tree');
    return p!;
  }

  @override
  bool updateShouldNotify(AppProvider old) =>
      student != old.student ||
      notes != old.notes ||
      isLoading != old.isLoading ||
      error != old.error;
}

/// Mengelola state dan menyediakan [AppProvider] ke subtree.
class AppProviderWrapper extends StatefulWidget {
  /// Widget anak.
  final Widget child;

  /// Membuat wrapper.
  const AppProviderWrapper({super.key, required this.child});

  @override
  State<AppProviderWrapper> createState() => _AppProviderWrapperState();
}

class _AppProviderWrapperState extends State<AppProviderWrapper> {
  final _repo = NoteRepository();

  Student _student = const Student(
    name: 'Nama Mahasiswa',
    nim: '000000000',
    programStudi: 'Teknik Informatika',
    email: 'mahasiswa@example.com',
  );
  List<Note> _notes = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final s = await _repo.getStudent();
      final n = await _repo.getNotes();
      if (!mounted) return;
      setState(() {
        if (s != null) _student = s;
        _notes = n;
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _error = 'Gagal memuat data.';
        _loading = false;
      });
    }
  }

  Future<void> _updateStudent(Student s) async {
    await _repo.saveStudent(s);
    setState(() => _student = s);
  }

  Future<void> _addNote(Note n) async {
    await _repo.addNote(n);
    setState(() => _notes = [n, ..._notes]);
  }

  Future<void> _deleteNote(String id) async {
    await _repo.deleteNote(id);
    setState(() => _notes = _notes.where((e) => e.id != id).toList());
  }

  @override
  Widget build(BuildContext context) => AppProvider(
    student: _student,
    notes: _notes,
    isLoading: _loading,
    error: _error,
    updateStudent: _updateStudent,
    addNote: _addNote,
    deleteNote: _deleteNote,
    child: widget.child,
  );
}
