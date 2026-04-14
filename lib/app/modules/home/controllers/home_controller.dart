import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:ujikom_project/app/models/catatan_model.dart';
import 'package:ujikom_project/app/models/jadwal_model.dart';
import 'package:ujikom_project/app/models/transaksi_model.dart';
import 'package:ujikom_project/app/routes/app_pages.dart';
import 'package:ujikom_project/app/services/auth_service.dart';
import 'package:ujikom_project/app/services/catatan_service.dart';
import 'package:ujikom_project/app/services/jadwal_service.dart';
import 'package:ujikom_project/app/services/toko_service.dart';
import 'package:ujikom_project/app/utils/api_helper.dart';

class HomeController extends GetxController {
  final _box = GetStorage();
  final _jadwalService = JadwalService();
  final _catatanService = CatatanService();
  final _authService = AuthService();
  final _tokoService = TokoService();

  // ================= USER STATE =================
  final userName = ''.obs;
  final userEmail = ''.obs;
  final userRole = ''.obs;
  final userAvatar = ''.obs;
  final kodePasien = ''.obs;
  final searchQuery = ''.obs;

  // ================= DATA STATE =================
  final jadwalList = <JadwalModel>[].obs;
  final catatanList = <CatatanModel>[].obs;
  final riwayatList = <TransaksiModel>[].obs;
  final isLoading = false.obs;
  final isLoggingOut = false.obs;
  final errorMessage = ''.obs;
  final catatanErrorMessage = ''.obs;
  final riwayatErrorMessage = ''.obs;
  final isLoadingRiwayat = false.obs;

  // ================= STATIC DATA =================
  final List<Map<String, dynamic>> layananList = [
    {'title': 'Jadwal', 'subtitle': 'Lihat jadwal obat', 'icon': 'calendar'},
    {'title': 'Catatan', 'subtitle': 'Riwayat kondisi', 'icon': 'note'},
    {
      'title': 'Notifikasi',
      'subtitle': 'Pantau jadwal harian',
      'icon': 'alarm'
    },
    {'title': 'Toko', 'subtitle': 'Beli obat online', 'icon': 'shop'},
  ];

  final List<Map<String, String>> infoList = [
    {
      'title': 'Tips hidrasi harian',
      'description':
          'Usahakan minum air putih 6-8 gelas setiap hari agar tubuh tetap terhidrasi.',
    },
    {
      'title': 'Cek obat rutin',
      'description': 'Pastikan obat diminum sesuai jam yang disarankan dokter.',
    },
    {
      'title': 'Istirahat cukup',
      'description': 'Tidur 7-8 jam membantu pemulihan tubuh.',
    },
  ];

  // ================= LIFECYCLE =================
  @override
  void onInit() {
    super.onInit();
    _loadUser();
    refreshAll();
  }

  // ================= METHODS =================
  Future<void> refreshAll() async {
    final token = _box.read('token');

    if (token == null || token.toString().isEmpty) {
      Get.offAllNamed(Routes.LOGIN);
      return;
    }

    await Future.wait([
      fetchJadwal(),
      fetchCatatan(),
      fetchRiwayat(),
    ]);
  }

  void _loadUser() {
    final user = _box.read<Map<String, dynamic>>('user');
    if (user == null) return;

    userName.value = user['name'] ?? '';
    userEmail.value = user['email'] ?? '';
    userRole.value = user['role'] ?? 'user';
    userAvatar.value = user['avatar'] ?? '';
    kodePasien.value = user['kode_pasien'] ?? '';
  }

  Future<void> fetchJadwal() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await _jadwalService.getJadwal();

      if (ApiHelper.isSuccessResponse(response.statusCode) &&
          response.body['success'] == true) {
        final rawData = response.body['data'] as List? ?? [];
        jadwalList.assignAll(
          rawData
              .whereType<Map<String, dynamic>>()
              .map((e) => JadwalModel.fromJson(e))
              .toList(),
        );
        return;
      }

      if (response.statusCode == 401) {
        await logout(showMessage: false);
        return;
      }

      errorMessage.value = response.body?['message']?.toString() ??
          ApiHelper.getErrorMessage(response.statusCode);
    } catch (e) {
      errorMessage.value = 'Gagal mengambil jadwal: $e';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchCatatan() async {
    try {
      catatanErrorMessage.value = '';

      final response = await _catatanService.getCatatan();

      if (ApiHelper.isSuccessResponse(response.statusCode) &&
          response.body['success'] == true) {
        final rawData = response.body['data'] as List? ?? [];
        catatanList.assignAll(
          rawData
              .whereType<Map<String, dynamic>>()
              .map((e) => CatatanModel.fromJson(e))
              .toList(),
        );
        return;
      }

      if (response.statusCode == 401) {
        await logout(showMessage: false);
        return;
      }

      catatanErrorMessage.value = response.body?['message']?.toString() ??
          ApiHelper.getErrorMessage(response.statusCode);
    } catch (e) {
      catatanErrorMessage.value = 'Gagal mengambil catatan: $e';
    }
  }

  Future<void> fetchRiwayat() async {
    try {
      isLoadingRiwayat.value = true;
      riwayatErrorMessage.value = '';

      final response = await _tokoService.getRiwayat();

      if (ApiHelper.isSuccessResponse(response.statusCode) &&
          response.body['success'] == true) {
        final rawData = response.body['data'] as List? ?? [];
        riwayatList.assignAll(
          rawData
              .whereType<Map<String, dynamic>>()
              .map((e) => TransaksiModel.fromJson(e))
              .toList(),
        );
        return;
      }

      if (response.statusCode == 401) {
        await logout(showMessage: false);
        return;
      }

      riwayatErrorMessage.value = response.body?['message']?.toString() ??
          ApiHelper.getErrorMessage(response.statusCode);
    } catch (e) {
      riwayatErrorMessage.value = 'Gagal mengambil riwayat: $e';
    } finally {
      isLoadingRiwayat.value = false;
    }
  }

  Future<void> logout({bool showMessage = true}) async {
    try {
      isLoggingOut.value = true;

      final token = _box.read('token');
      if (token != null) {
        await _authService.logout(token.toString());
      }
    } catch (_) {
      // ignore error
    } finally {
      _box.remove('token');
      _box.remove('user');

      jadwalList.clear();
      catatanList.clear();
      riwayatList.clear();

      userName.value = '';
      userEmail.value = '';
      kodePasien.value = '';

      isLoggingOut.value = false;

      Get.offAllNamed(Routes.LOGIN);

      if (showMessage) {
        Get.snackbar('Logout', 'Sesi berhasil diakhiri');
      }
    }
  }

  void updateSearch(String value) {
    searchQuery.value = value;
  }

  // ================= GETTER =================
  int get totalNotifikasiAktif =>
      jadwalList.where((item) => item.statusPengingat).length;
}
