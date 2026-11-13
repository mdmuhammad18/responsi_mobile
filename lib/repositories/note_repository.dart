import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/note.dart';
import '../models/student.dart';
import '../services/secure_storage_service.dart';

/// Repository pattern: satu pintu akses data catatan & profil.
class NoteRepository {
  static const _notesKey = 'notes_meta';
  static const _studentKey = 'student_profile';

  final SecureStorageService _secure;

  /// Membuat repository dengan [SecureStorageService] opsional.
  NoteRepository({SecureStorageService? secure})
    : _secure = secure ?? SecureStorageService();

  Future<List<Map<String, dynamic>>> _loadMetas() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_notesKey);
    if (raw == null) return [];
    return (jsonDecode(raw) as List<dynamic>).cast<Map<String, dynamic>>();
  }

  Future<void> _saveMetas(List<Map<String, dynamic>> metas) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_notesKey, jsonEncode(metas));
  }

  /// Mengambil semua catatan (metadata + isi terdekripsi).
  Future<List<Note>> getNotes() async {
    final metas = await _loadMetas();
    final notes = <Note>[];
    for (final m in metas) {
      final content = await _secure.getContent(m['id'] as String) ?? '';
      notes.add(Note.fromMeta(m, content: content));
    }
    return notes;
  }

  /// Menyimpan catatan baru: isi ke secure storage, metadata ke prefs.
  Future<void> addNote(Note note) async {
    await _secure.saveContent(note.id, note.content);
    final metas = await _loadMetas();
    metas.insert(0, note.toMeta());
    await _saveMetas(metas);
  }

  /// Menghapus catatan berdasarkan [id] (metadata dan isi).
  Future<void> deleteNote(String id) async {
    await _secure.deleteContent(id);
    final metas = await _loadMetas();
    metas.removeWhere((m) => m['id'] == id);
    await _saveMetas(metas);
  }

  /// Mengambil profil tersimpan; `null` jika belum ada.
  Future<Student?> getStudent() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_studentKey);
    if (raw == null) return null;
    return Student.fromJson(jsonDecode(raw) as Map<String, dynamic>);
  }

  /// Menyimpan profil mahasiswa.
  Future<void> saveStudent(Student s) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_studentKey, jsonEncode(s.toJson()));
  }
}
