class BaseUrl {
  // ─── Base ──────────────────────────────────────────────────────────
  static String base = 'http://127.0.0.1:8000';
  static String storageUrl = 'http://127.0.0.1:8000/storage';

  // ─── Auth ──────────────────────────────────────────────────────────
  static String login = '$base/api/login';
  static String register = '$base/api/register';
  static String logout = '$base/api/logout';

  // ─── Default Headers ───────────────────────────────────────────────
  static Map<String, String> defaultHeaders = {
    'Accept': 'application/json',
  };

  // ─── Auth Headers ──────────────────────────────────────────────────
  static Map<String, String> authHeaders(String token) => {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      };

  // ─── Status Codes ──────────────────────────────────────────────────
  static int success = 200;
  static int created = 201;
  static int badRequest = 400;
  static int unauthorized = 401;
  static int notFound = 404;
  static int serverError = 500;

  // ─── Helper: build full image URL ──────────────────────────────────
  static String getImageUrl(String path) {
    if (path.isEmpty) return '';
    if (path.startsWith('http')) return path;
    return '$storageUrl/$path';
  }
}
