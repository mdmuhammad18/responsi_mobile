/// Kumpulan validasi dan sanitasi input.
class Validators {
  Validators._();

  /// Validasi judul: 3–50 karakter.
  static String? validateTitle(String? v) {
    final s = (v ?? '').trim();
    if (s.isEmpty) return 'Judul wajib diisi';
    if (s.length < 3) return 'Judul minimal 3 karakter';
    if (s.length > 50) return 'Judul maksimal 50 karakter';
    return null;
  }

  /// Validasi isi: 10–1000 karakter.
  static String? validateContent(String? v) {
    final s = (v ?? '').trim();
    if (s.isEmpty) return 'Isi catatan wajib diisi';
    if (s.length < 10) return 'Isi minimal 10 karakter';
    if (s.length > 1000) return 'Isi maksimal 1000 karakter';
    return null;
  }

  /// Validasi teks wajib (untuk field profil).
  static String? validateRequired(String? v, String label) =>
      (v ?? '').trim().isEmpty ? '$label wajib diisi' : null;

  /// Validasi format email sederhana.
  static String? validateEmail(String? v) {
    final s = (v ?? '').trim();
    if (s.isEmpty) return 'Email wajib diisi';
    if (!RegExp(r'^[\w.+-]+@[\w-]+\.[\w.-]+$').hasMatch(s)) {
      return 'Format email tidak valid';
    }
    return null;
  }

  /// Membersihkan karakter berbahaya: < > " '
  static String sanitize(String input) =>
      input.replaceAll(RegExp('[<>"\']'), '').trim();
}
