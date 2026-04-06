import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:ujikom_project/app/routes/app_pages.dart';
import 'package:ujikom_project/app/services/auth_service.dart';

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
    if (token != null) {
      Get.offAllNamed(Routes.HOME);
    }
  }

  Future<void> login(String email, String password,
      {VoidCallback? onSuccess}) async {
    if (email.isEmpty || password.isEmpty) {
      Get.snackbar(
        'Peringatan',
        'Email dan password tidak boleh kosong',
        backgroundColor: Colors.orange,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    try {
      isLoading(true);
      final response = await api.login(email, password);

      if (response.statusCode == 200 && response.body['success'] == true) {
        final token = response.body['token'];
        final user = response.body['data'];

        onSuccess?.call();
        box.write('token', token);
        box.write('user', user);
        Get.offAllNamed(Routes.HOME);

        Get.snackbar(
          'Berhasil',
          response.body['message'] ?? 'Login berhasil!',
          backgroundColor: const Color(0xFF10B981),
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
        );
      } else {
        Get.snackbar(
          'Gagal Login',
          response.body['message'] ?? 'Email atau password salah',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Terjadi kesalahan: ${e.toString()}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      isLoading(false);
    }
  }

  Future<void> register(String name, String email, String password,
      {VoidCallback? onSuccess}) async {
    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      Get.snackbar(
        'Peringatan',
        'Semua field harus diisi',
        backgroundColor: Colors.orange,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    try {
      isLoading(true);
      final response = await api.register(name, email, password);

      if ((response.statusCode == 200 || response.statusCode == 201) &&
          response.body['success'] == true) {
        onSuccess?.call();
        Get.offAllNamed(Routes.LOGIN);

        Get.snackbar(
          'Berhasil',
          response.body['message'] ?? 'Registrasi berhasil. Silakan login.',
          backgroundColor: const Color(0xFF10B981),
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
        );
      } else if (response.statusCode == 422) {
        final errors = response.body['errors'] as Map<String, dynamic>?;
        final firstError = errors?.values.first;
        final errorMsg = firstError is List
            ? firstError.first.toString()
            : firstError?.toString() ?? 'Data tidak valid';

        Get.snackbar(
          'Gagal Registrasi',
          errorMsg,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
        );
      } else {
        Get.snackbar(
          'Gagal Registrasi',
          response.body['message'] ?? 'Registrasi gagal',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Terjadi kesalahan: ${e.toString()}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      isLoading(false);
    }
  }

  Future<void> logout() async {
    try {
      final token = box.read('token');
      if (token != null) {
        await api.logout(token);
      }
    } catch (_) {
    } finally {
      box.remove('token');
      box.remove('user');
      Get.offAllNamed(Routes.LOGIN);
    }
  }

  Map<String, dynamic>? get currentUser {
    return box.read<Map<String, dynamic>>('user');
  }

  String get userName => currentUser?['name'] ?? '';
  String get userRole => currentUser?['role'] ?? 'user';
  String get kodePasien => currentUser?['kode_pasien'] ?? '';
}
