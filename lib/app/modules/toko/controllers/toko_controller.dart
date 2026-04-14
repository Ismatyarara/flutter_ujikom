import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:ujikom_project/app/models/obat_model.dart';
import 'package:ujikom_project/app/models/transaksi_model.dart';
import 'package:ujikom_project/app/services/toko_service.dart';
import 'package:ujikom_project/app/utils/api_helper.dart';
import 'package:flutter/material.dart';

class TokoController extends GetxController {
  final _service = TokoService();
  final _box = GetStorage();

  // ─── Obat State ───────────────────────────────────────────────────────────
  final RxList<ObatModel> obatList = <ObatModel>[].obs;
  final RxBool isLoadingObat = false.obs;
  final RxString obatError = ''.obs;
  final RxString searchQuery = ''.obs;

  // ─── Keranjang State ──────────────────────────────────────────────────────
  final RxMap<int, int> keranjang = <int, int>{}.obs; // id_obat → jumlah

  // ─── Checkout State ───────────────────────────────────────────────────────
  final RxBool isCheckingOut = false.obs;
  final alamatController = TextEditingController();
  final teleponController = TextEditingController();
  final catatanController = TextEditingController();

  // ─── Riwayat State ────────────────────────────────────────────────────────
  final RxList<TransaksiModel> riwayatList = <TransaksiModel>[].obs;
  final RxBool isLoadingRiwayat = false.obs;
  final RxString riwayatError = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchObat();
    fetchRiwayat();
  }

  @override
  void onClose() {
    alamatController.dispose();
    teleponController.dispose();
    catatanController.dispose();
    super.onClose();
  }

  // ─── Fetch Obat ───────────────────────────────────────────────────────────
  Future<void> fetchObat({String? search}) async {
    try {
      isLoadingObat.value = true;
      obatError.value = '';
      final response = await _service.getObat(search: search);

      if (ApiHelper.isSuccessResponse(response.statusCode) &&
          response.body['success'] == true) {
        final data = (response.body['data'] as List? ?? [])
            .whereType<Map<String, dynamic>>()
            .map(ObatModel.fromJson)
            .toList();
        obatList.assignAll(data);
      } else {
        obatError.value = response.body?['message'] ?? 'Gagal memuat obat';
      }
    } catch (e) {
      obatError.value = 'Koneksi gagal. Pastikan server aktif.';
    } finally {
      isLoadingObat.value = false;
    }
  }

  void onSearch(String value) {
    searchQuery.value = value;
    fetchObat(search: value.isEmpty ? null : value);
  }

  // ─── Keranjang ────────────────────────────────────────────────────────────
  void tambahKeranjang(int idObat) {
    keranjang[idObat] = (keranjang[idObat] ?? 0) + 1;
  }

  void kurangKeranjang(int idObat) {
    if ((keranjang[idObat] ?? 0) <= 1) {
      keranjang.remove(idObat);
    } else {
      keranjang[idObat] = keranjang[idObat]! - 1;
    }
  }

  void hapusKeranjang(int idObat) => keranjang.remove(idObat);

  int jumlahDiKeranjang(int idObat) => keranjang[idObat] ?? 0;

  int get totalItemKeranjang => keranjang.values.fold(0, (a, b) => a + b);

  double get totalHargaKeranjang {
    double total = 0;
    keranjang.forEach((idObat, jumlah) {
      final obat = obatList.firstWhereOrNull((o) => o.id == idObat);
      if (obat != null) total += obat.harga * jumlah;
    });
    return total;
  }

  List<ObatModel> get obatDiKeranjang =>
      obatList.where((o) => keranjang.containsKey(o.id)).toList();

  // ─── Checkout ─────────────────────────────────────────────────────────────
  Future<void> checkout() async {
    if (alamatController.text.isEmpty || teleponController.text.isEmpty) {
      Get.snackbar('Error', 'Alamat dan nomor telepon wajib diisi');
      return;
    }

    try {
      isCheckingOut.value = true;

      final items = keranjang.entries
          .map((e) => {
                'id_obat': e.key,
                'jumlah': e.value,
              })
          .toList();

      final body = {
        'items': items,
        'alamat_pengiriman': alamatController.text,
        'no_telepon': teleponController.text,
        'catatan': catatanController.text,
      };

      final response = await _service.beli(body);

      if (response.statusCode == 201 && response.body['success'] == true) {
        keranjang.clear();
        alamatController.clear();
        teleponController.clear();
        catatanController.clear();
        await fetchRiwayat();
        Get.back();
        Get.back();
        Get.snackbar('Berhasil', 'Pesanan berhasil dibuat!',
            snackPosition: SnackPosition.BOTTOM);
      } else {
        Get.snackbar('Gagal', response.body?['message'] ?? 'Gagal checkout');
      }
    } catch (e) {
      Get.snackbar('Error', 'Koneksi gagal');
    } finally {
      isCheckingOut.value = false;
    }
  }

  // ─── Riwayat ──────────────────────────────────────────────────────────────
  Future<void> fetchRiwayat() async {
    try {
      isLoadingRiwayat.value = true;
      riwayatError.value = '';
      final response = await _service.getRiwayat();

      if (ApiHelper.isSuccessResponse(response.statusCode) &&
          response.body['success'] == true) {
        final data = (response.body['data'] as List? ?? [])
            .whereType<Map<String, dynamic>>()
            .map(TransaksiModel.fromJson)
            .toList();
        riwayatList.assignAll(data);
      } else {
        riwayatError.value =
            response.body?['message'] ?? 'Gagal memuat riwayat';
      }
    } catch (e) {
      riwayatError.value = 'Koneksi gagal.';
    } finally {
      isLoadingRiwayat.value = false;
    }
  }
}
