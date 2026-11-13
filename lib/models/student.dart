/// Model data profil mahasiswa.
class Student {
  /// Nama lengkap.
  final String name;

  /// Nomor Induk Mahasiswa.
  final String nim;

  /// Program studi.
  final String programStudi;

  /// Alamat email.
  final String email;

  /// Membuat objek [Student].
  const Student({
    required this.name,
    required this.nim,
    required this.programStudi,
    required this.email,
  });

  /// Inisial nama (maks. 2 huruf) untuk CircleAvatar.
  String get initials {
    final parts = name
        .trim()
        .split(RegExp(r'\s+'))
        .where((e) => e.isNotEmpty)
        .toList();
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return (parts.first[0] + parts[1][0]).toUpperCase();
  }

  /// Konversi ke JSON.
  Map<String, dynamic> toJson() => {
    'name': name,
    'nim': nim,
    'programStudi': programStudi,
    'email': email,
  };

  /// Membuat [Student] dari JSON.
  factory Student.fromJson(Map<String, dynamic> j) => Student(
    name: j['name'] as String? ?? '',
    nim: j['nim'] as String? ?? '',
    programStudi: j['programStudi'] as String? ?? '',
    email: j['email'] as String? ?? '',
  );
}
