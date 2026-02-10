import 'package:get/get.dart';

class HomeController extends GetxController {
  final count = 0.obs;

  // Fungsi untuk logout
  void logout() {
    // 1. Logika hapus session (jika ada GetStorage/SharedPrefs) bisa di sini

    // 2. Arahkan ke halaman login
    // Get.offAllNamed memastikan user tidak bisa balik lagi ke Home pakai tombol back
    Get.offAllNamed('/login');

    // 3. Opsional: Kasih notifikasi manja
    Get.snackbar(
      'Logout',
      'Kamu telah berhasil keluar.',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void increment() => count.value++;

  @override
  void onInit() => super.onInit();

  @override
  void onReady() => super.onReady();

  @override
  void onClose() => super.onClose();
}
