import 'package:get/get.dart';

import '../utils/api.dart';

class AuthService extends GetConnect {
  @override
  void onInit() {
    httpClient.defaultContentType = 'application/json';
    httpClient.timeout = const Duration(seconds: 12);
    httpClient.addRequestModifier<dynamic>((request) {
      request.headers.addAll(BaseUrl.defaultHeaders);
      return request;
    });
    super.onInit();
  }

  Future<Response> login(String email, String password) {
    return post(BaseUrl.login, {'email': email, 'password': password});
  }

  Future<Response> register(
    String name,
    String email,
    String password,
    String passwordConfirmation,
  ) {
    return post(BaseUrl.register, {
      'name': name,
      'email': email,
      'password': password,
      'password_confirmation': passwordConfirmation,
    });
  }

  Future<Response> verifyOtp(String email, String otp) {
    return post(BaseUrl.verifyOtp, {
      'email': email,
      'otp': otp,
    });
  }

  Future<Response> logout(String token) {
    return post(BaseUrl.logout, {}, headers: BaseUrl.authHeaders(token));
  }
}
