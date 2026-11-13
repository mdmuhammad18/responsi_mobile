import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Konfigurasi aplikasi yang dimuat dari file `.env`.
/// Tidak ada credential yang ditulis langsung (hardcoded) di kode.
class AppConfig {
  AppConfig._();

  /// Memuat file `.env`. Panggil sekali di `main()`.
  static Future<void> load() => dotenv.load(fileName: '.env');

  /// URL dasar API publik.
  static String get baseUrl =>
      dotenv.env['BASE_URL'] ?? 'https://jsonplaceholder.typicode.com';

  /// API key (dummy). Jangan pernah dicetak ke log.
  static String get apiKey => dotenv.env['API_KEY'] ?? '';
}
