import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Layanan penyimpanan isi catatan secara terenkripsi.
class SecureStorageService {
  final FlutterSecureStorage _storage;

  /// Membuat service. Android memakai EncryptedSharedPreferences.
  SecureStorageService({FlutterSecureStorage? storage})
    : _storage =
          storage ??
          const FlutterSecureStorage(
            aOptions: AndroidOptions(encryptedSharedPreferences: true),
          );

  String _key(String noteId) => 'note_content_$noteId';

  /// Menyimpan [content] terenkripsi untuk catatan [noteId].
  Future<void> saveContent(String noteId, String content) =>
      _storage.write(key: _key(noteId), value: content);

  /// Membaca isi catatan [noteId]; `null` jika tidak ada.
  Future<String?> getContent(String noteId) => _storage.read(key: _key(noteId));

  /// Menghapus isi catatan [noteId].
  Future<void> deleteContent(String noteId) =>
      _storage.delete(key: _key(noteId));
}
