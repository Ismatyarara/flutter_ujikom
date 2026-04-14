import 'dart:convert';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:ujikom_project/app/models/jadwal_model.dart';
import 'package:ujikom_project/app/utils/api.dart';

class JadwalController extends GetxController {
  final _box = GetStorage();

  // ─── State ────────────────────────────────────────────────────────────────
  final RxList<JadwalModel> jadwalList = <JadwalModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxString filterStatus = 'semua'.obs;

  String get _token => _box.read('token')?.toString() ?? '';

  List<JadwalModel> get filteredList {
    if (filterStatus.value == 'semua') return jadwalList;
    return jadwalList
        .where((j) => j.status.toLowerCase() == filterStatus.value)
        .toList();
  }

  // ─── Lifecycle ────────────────────────────────────────────────────────────
  @override
  void onInit() {
    super.onInit();
    fetchJadwal();
  }

  // ─── API Call ─────────────────────────────────────────────────────────────
  Future<void> fetchJadwal() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await http.get(
        Uri.parse(BaseUrl.jadwal),
        headers: BaseUrl.authHeaders(_token),
      );

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        final List data = body['data'] ?? [];
        jadwalList.value = data.map((e) => JadwalModel.fromJson(e)).toList();
      } else if (response.statusCode == 401) {
        errorMessage.value = 'Sesi habis, silakan login ulang.';
      } else {
        errorMessage.value = 'Gagal memuat jadwal (${response.statusCode})';
      }
    } catch (e) {
      errorMessage.value = 'Koneksi gagal. Pastikan server aktif.';
    } finally {
      isLoading.value = false;
    }
  }

  // ─── Actions ──────────────────────────────────────────────────────────────
  void setFilter(String status) => filterStatus.value = status;

  void refresh() => fetchJadwal();
}
