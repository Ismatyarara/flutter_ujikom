class BaseUrl {
  // Auth endpoints
  static String login = 'http://localhost:8000/api/login';
  static String register = 'http://localhost:8000/api/register';
  static String logout = 'http://localhost:8000/api/logout';

  // Storage URL untuk gambar
  static String storageUrl = 'http://localhost:8000/storage';

  // Headers
  static Map<String, String> defaultHeaders = {
    'Accept': 'application/json',
    'Content-Type': 'application/json',
  };

  // Headers with auth token
  static Map<String, String> authHeaders(String token) => {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

  // Status codes
  static int success = 200;
  static int created = 201;
  static int badRequest = 400;
  static int unauthorized = 401;
  static int notFound = 404;
  static int serverError = 500;
}
