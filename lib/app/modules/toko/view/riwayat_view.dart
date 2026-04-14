import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ujikom_project/app/modules/toko/controllers/toko_controller.dart';
import 'package:ujikom_project/app/models/transaksi_model.dart';

class RiwayatView extends StatelessWidget {
  const RiwayatView({super.key});

  static const kNavy = Color(0xFF0C1D3B);
  static const kBlue = Color(0xFF1A56DB);
  static const kBg = Color(0xFFF4F7FF);

  @override
  Widget build(BuildContext context) {
    // ✅ Pakai Get.put dengan permanent: false dan tag supaya tidak konflik
    // Kalau TokoController sudah ada (dari ObatListView), pakai yang sudah ada
    final controller = Get.isRegistered<TokoController>()
        ? Get.find<TokoController>()
        : Get.put(TokoController());

    return Scaffold(
      backgroundColor: kBg,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: kNavy,
        elevation: 0,
        title: const Text(
          'Riwayat Pembelian',
          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: controller.fetchRiwayat,
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoadingRiwayat.value) {
          return const Center(child: CircularProgressIndicator(color: kBlue));
        }

        if (controller.riwayatError.value.isNotEmpty) {
          return Center(
            child: Text(
              controller.riwayatError.value,
              style: const TextStyle(color: Colors.black45),
            ),
          );
        }

        if (controller.riwayatList.isEmpty) {
          return const Center(child: Text('Belum ada riwayat pembelian'));
        }

        return RefreshIndicator(
          color: kBlue,
          onRefresh: controller.fetchRiwayat,
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: controller.riwayatList.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (_, i) =>
                _TransaksiCard(transaksi: controller.riwayatList[i]),
          ),
        );
      }),
    );
  }
}

class _TransaksiCard extends StatelessWidget {
  const _TransaksiCard({required this.transaksi});
  final TransaksiModel transaksi;

  static const kNavy = Color(0xFF0C1D3B);
  static const kBlue = Color(0xFF1A56DB);

  @override
  Widget build(BuildContext context) {
    final statusColor = _statusColor(transaksi.status);

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
              color: Color(0x10000000), blurRadius: 14, offset: Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  transaksi.kodeTransaksi,
                  style: const TextStyle(
                      fontWeight: FontWeight.w800, color: kNavy, fontSize: 14),
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  transaksi.status.toUpperCase(),
                  style: TextStyle(
                      color: statusColor,
                      fontWeight: FontWeight.w700,
                      fontSize: 11),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...transaksi.items.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  children: [
                    const Icon(Icons.medication_rounded,
                        size: 16, color: Colors.black38),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '${item.namaObat} x${item.jumlah}',
                        style: const TextStyle(color: Colors.black54),
                      ),
                    ),
                    Text(
                      'Rp ${_formatHarga(item.subtotal)}',
                      style: const TextStyle(color: Colors.black54),
                    ),
                  ],
                ),
              )),
          const Divider(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                transaksi.createdAt.length >= 10
                    ? transaksi.createdAt.substring(0, 10)
                    : transaksi.createdAt,
                style: TextStyle(color: Colors.blueGrey.shade500, fontSize: 12),
              ),
              Text(
                'Total: Rp ${_formatHarga(transaksi.totalHarga)}',
                style: const TextStyle(
                    fontWeight: FontWeight.w800, color: kBlue, fontSize: 14),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'dibayar':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'expired':
        return Colors.grey;
      case 'dibatalkan':
        return Colors.red;
      default:
        return Colors.blue;
    }
  }

  String _formatHarga(double harga) =>
      harga.toStringAsFixed(0).replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.');
}
