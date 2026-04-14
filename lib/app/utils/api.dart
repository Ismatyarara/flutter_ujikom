import 'package:flutter/foundation.dart';

class BaseUrl {
  static const String manualBaseUrl =
      String.fromEnvironment('API_BASE_URL', defaultValue: '');


static String get base {
    if (manualBaseUrl.isNotEmpty) return manualBaseUrl;
    if (kIsWeb) return 'http://127.0.0.1:8000';
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return 'http://10.0.2.2:8000';
      default:
        return 'http://127.0.0.1:8000';
    }
  }
  static String get storageUrl => '$base/storage';

  // ─── Endpoints ────────────────────────────────────────────────────────────
  static String get login => '$base/api/login';
  static String get register => '$base/api/register';
  static String get verifyOtp => '$base/api/verify-otp';
  static String get logout => '$base/api/logout';
  static String get jadwal => '$base/api/jadwal';
  static String get catatan => '$base/api/catatan';
  static String get mobileHome => '$base/api/mobile/home';
  static String get obat => '$base/api/obat';
  static String get tokoBeli => '$base/api/toko/beli';
  static String get tokoRiwayat => '$base/api/toko/riwayat';

  // ─── Headers ──────────────────────────────────────────────────────────────
  static const Map<String, String> defaultHeaders = {
    'Accept': 'application/json',
  };

  static Map<String, String> authHeaders(String token) => {
        ...defaultHeaders,
        'Authorization': 'Bearer $token',
      };

  // ─── Status Codes ─────────────────────────────────────────────────────────
  static const int success = 200;
  static const int created = 201;
  static const int badRequest = 400;
  static const int unauthorized = 401;
  static const int forbidden = 403;
  static const int notFound = 404;
  static const int validationError = 422;
  static const int serverError = 500;

  // ─── Image URL Helper ─────────────────────────────────────────────────────
  static String getImageUrl(String? path) {
    if (path == null || path.isEmpty) return '';

    for (final origin in [
      'http://localhost:8000',
      'http://127.0.0.1:8000',
      'http://localhost/ujikom/public', // ✅ lebih spesifik, urutan pertama
      'http://localhost',
    ]) {
      if (path.startsWith(origin)) {
        return path.replaceFirst(origin, base);
      }
    }

    if (path.startsWith('http')) return path;

    return '$storageUrl/$path';
  }
}