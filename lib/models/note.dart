/// Model catatan kuliah.
///
/// Metadata ([id], [title], [createdAt]) disimpan di SharedPreferences,
/// sedangkan [content] disimpan terenkripsi di flutter_secure_storage.
class Note {
  /// ID unik catatan.
  final String id;

  /// Judul catatan.
  final String title;

  /// Waktu pembuatan.
  final DateTime createdAt;

  /// Isi catatan (tidak ikut disimpan di metadata).
  final String content;

  /// Membuat objek [Note].
  const Note({
    required this.id,
    required this.title,
    required this.createdAt,
    this.content = '',
  });

  /// Metadata saja (tanpa isi) untuk SharedPreferences.
  Map<String, dynamic> toMeta() => {
    'id': id,
    'title': title,
    'createdAt': createdAt.toIso8601String(),
  };

  /// Membuat [Note] dari metadata + isi.
  factory Note.fromMeta(Map<String, dynamic> m, {String content = ''}) => Note(
    id: m['id'] as String,
    title: m['title'] as String? ?? '',
    createdAt:
        DateTime.tryParse(m['createdAt'] as String? ?? '') ?? DateTime.now(),
    content: content,
  );
}
