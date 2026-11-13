import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../config/app_config.dart';

/// Layanan HTTP GET ke API publik.
class ApiService {
  /// Mengambil daftar pengguna dari `/users`.
  ///
  /// Melempar [Exception] dengan pesan ramah pengguna jika gagal.
  Future<List<Map<String, dynamic>>> fetchUsers() async {
    final uri = Uri.parse('${AppConfig.baseUrl}/users');
    try {
      final res = await http
          .get(
            uri,
            headers: {
              'Accept': 'application/json',
              'x-api-key': AppConfig.apiKey,
            },
          )
          .timeout(const Duration(seconds: 10));
      // Log aman: hanya status code, tanpa header/token/body.
      debugPrint('GET /users -> ${res.statusCode}');
      if (res.statusCode != 200) {
        throw Exception('Server error (${res.statusCode})');
      }
      final data = jsonDecode(res.body) as List<dynamic>;
      return data.cast<Map<String, dynamic>>();
    } on SocketException {
      throw Exception('Tidak ada koneksi internet.');
    } on TimeoutException {
      throw Exception('Permintaan melebihi batas waktu.');
    } on FormatException {
      throw Exception('Format data dari server tidak valid.');
    }
  }
}
