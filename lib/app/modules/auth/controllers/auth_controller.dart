import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:ujikom_project/app/routes/app_pages.dart';
import 'package:ujikom_project/app/services/auth_service.dart';
import 'package:ujikom_project/app/utils/api.dart';

class AuthController extends GetxController {
  final AuthService api = AuthService();
  final box = GetStorage();

  RxBool isLoading = false.obs;
  RxBool isPasswordHidden = true.obs;

  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  @override
  void onInit() {
    super.onInit();
    final token = box.read('token');
    if (token != null && token.toString().isNotEmpty) {
      Get.offAllNamed(Routes.HOME);
    }
  }

  Future<void> login(
    String email,
    String password, {
    VoidCallback? onSuccess,
  }) async {
    if (email.isEmpty || password.isEmpty) {
      _showSnack('Peringatan', 'Email dan password tidak boleh kosong', Colors.orange);
      return;
    }

    try {
      isLoading(true);
      final response = await api.login(email, password).timeout(const Duration(seconds: 15));
      final body = response.body is Map<String, dynamic>
          ? response.body as Map<String, dynamic>
          : Map<String, dynamic>.from(response.body ?? {});

      if (response.statusCode == 200 && body['success'] == true) {
        final hasToken = _saveAuth(body);
        if (!hasToken) {
          _showSnack(
            'Login Gagal',
            'API tidak mengirim token login. Periksa konfigurasi backend ujikom.',
            Colors.red,
          );
          return;
        }
        onSuccess?.call();
        Get.offAllNamed(Routes.HOME);
        _showSnack('Berhasil', body['message']?.toString() ?? 'Login berhasil!', const Color(0xFF10B981));
        return;
      }

      if (response.statusCode == BaseUrl.forbidden && body['requires_otp'] == true) {
        _showSnack(
          'Perlu OTP Dari Backend',
          'API ujikom masih mewajibkan verifikasi OTP untuk email ini. Tanpa mengubah backend, Flutter tidak bisa langsung login.',
          Colors.orange,
        );
        return;
      }

      _showSnack(
        'Gagal Login',
        _extractMessage(response.body, fallback: 'Email atau password salah'),
        Colors.red,
      );
    } catch (e) {
      _showSnack('Error', _networkMessage(e), Colors.red);
    } finally {
      isLoading(false);
    }
  }

  Future<void> register(
    String name,
    String email,
    String password,
    String passwordConfirmation, {
    VoidCallback? onSuccess,
  }) async {
    if (name.isEmpty || email.isEmpty || password.isEmpty || passwordConfirmation.isEmpty) {
      _showSnack('Peringatan', 'Semua field harus diisi', Colors.orange);
      return;
    }

    if (password != passwordConfirmation) {
      _showSnack('Peringatan', 'Password dan konfirmasi password tidak sama', Colors.orange);
      return;
    }

    try {
      isLoading(true);
      final response = await api
          .register(name, email, password, passwordConfirmation)
          .timeout(const Duration(seconds: 15));
      final body = response.body is Map<String, dynamic>
          ? response.body as Map<String, dynamic>
          : Map<String, dynamic>.from(response.body ?? {});

      if ((response.statusCode == 200 || response.statusCode == 201) && body['success'] == true) {
        final hasToken = _saveAuth(body);
        onSuccess?.call();

        if (hasToken) {
          Get.offAllNamed(Routes.HOME);
          _showSnack('Berhasil', body['message']?.toString() ?? 'Registrasi berhasil.', const Color(0xFF10B981));
          return;
        }

        if (body['requires_otp'] == true) {
          _showSnack(
            'Register Berhasil, Tapi Backend Masih Minta OTP',
            'API ujikom mengirim respons verifikasi OTP. Tanpa ubah backend, akun belum bisa langsung dipakai login di Flutter.',
            Colors.orange,
          );
          return;
        }

        _showSnack(
          'Register Belum Selesai',
          'Registrasi tidak mengembalikan token. Periksa alur auth backend ujikom.',
          Colors.red,
        );
        return;
      }

      _showSnack(
        'Gagal Registrasi',
        _extractMessage(response.body, fallback: 'Registrasi gagal'),
        Colors.red,
      );
    } catch (e) {
      _showSnack('Error', _networkMessage(e), Colors.red);
    } finally {
      isLoading(false);
    }
  }

  Future<void> logout() async {
    try {
      final token = box.read('token');
      if (token != null) {
        await api.logout(token.toString()).timeout(const Duration(seconds: 15));
      }
    } catch (_) {
    } finally {
      box.remove('token');
      box.remove('user');
      Get.offAllNamed(Routes.LOGIN);
    }
  }

  bool _saveAuth(Map<String, dynamic> body) {
    final token = body['token'];
    final user = body['data'];

    if (token != null) {
      box.write('token', token);
    }
    if (user != null) {
      box.write('user', user);
    }
    return token != null;
  }

  String _extractMessage(dynamic body, {required String fallback}) {
    if (body is Map) {
      final message = body['message'];
      if (message != null && message.toString().isNotEmpty) {
        return message.toString();
      }

      final errors = body['errors'];
      if (errors is Map && errors.isNotEmpty) {
        final firstError = errors.values.first;
        if (firstError is List && firstError.isNotEmpty) {
          return firstError.first.toString();
        }
        return firstError.toString();
      }
    }

    return fallback;
  }

  String _networkMessage(Object e) {
    final text = e.toString().toLowerCase();
    if (text.contains('timeout')) {
      return kIsWeb
          ? 'Request terlalu lama. Pastikan Laravel aktif di ${BaseUrl.base} dan browser bisa mengaksesnya.'
          : 'Request terlalu lama. Pastikan Laravel aktif dan emulator bisa akses ${BaseUrl.base}.';
    }
    if (text.contains('socketexception') || text.contains('connection')) {
      return kIsWeb
          ? 'Koneksi ke Laravel gagal dari browser. Pastikan `php artisan serve` aktif di ${BaseUrl.base}. Jika perlu, cek juga error CORS di browser console.'
          : 'Koneksi ke Laravel gagal. Pastikan `php artisan serve` aktif di ${BaseUrl.base}.';
    }
    return 'Terjadi kesalahan: $e';
  }

  void _showSnack(String title, String message, Color color) {
    Get.snackbar(
      title,
      message,
      backgroundColor: color,
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
    );
  }
}
