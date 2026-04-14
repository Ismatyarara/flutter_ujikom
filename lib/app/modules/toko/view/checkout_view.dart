import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ujikom_project/app/modules/toko/controllers/toko_controller.dart';
class CheckoutView extends StatelessWidget {
  const CheckoutView({super.key});

  static const kNavy = Color(0xFF0C1D3B);
  static const kBlue = Color(0xFF1A56DB);
  static const kBg = Color(0xFFF4F7FF);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TokoController>();

    return Scaffold(
      backgroundColor: kBg,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: kNavy,
        elevation: 0,
        title: const Text('Checkout',
            style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Daftar item
            _sectionTitle('Pesanan'),
            const SizedBox(height: 12),
            Obx(() => Column(
                  children: controller.obatDiKeranjang.map((obat) {
                    final jumlah = controller.jumlahDiKeranjang(obat.id);
                    return Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: const Color(0xFFEAF1FF),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(Icons.medication_rounded,
                                color: kBlue),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(obat.namaObat,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w700,
                                        color: kNavy)),
                                Text(
                                    '${jumlah}x · Rp ${_formatHarga(obat.harga)}',
                                    style: TextStyle(
                                        color: Colors.blueGrey.shade500,
                                        fontSize: 12)),
                              ],
                            ),
                          ),
                          Text('Rp ${_formatHarga(obat.harga * jumlah)}',
                              style: const TextStyle(
                                  color: kBlue, fontWeight: FontWeight.w800)),
                          const SizedBox(width: 8),
                          GestureDetector(
                            onTap: () => controller.hapusKeranjang(obat.id),
                            child: const Icon(Icons.close_rounded,
                                color: Colors.black26, size: 20),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                )),

            const SizedBox(height: 20),

            // Total
            Obx(() => Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEFF6FF),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Total',
                          style: TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 16,
                              color: kNavy)),
                      Text('Rp ${_formatHarga(controller.totalHargaKeranjang)}',
                          style: const TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 16,
                              color: kBlue)),
                    ],
                  ),
                )),

            const SizedBox(height: 24),

            // Form pengiriman
            _sectionTitle('Informasi Pengiriman'),
            const SizedBox(height: 12),
            _inputField(
              controller: controller.alamatController,
              label: 'Alamat Pengiriman',
              hint: 'Jl. Contoh No. 1',
              maxLines: 3,
            ),
            const SizedBox(height: 12),
            _inputField(
              controller: controller.teleponController,
              label: 'Nomor Telepon',
              hint: '08123456789',
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 12),
            _inputField(
              controller: controller.catatanController,
              label: 'Catatan (opsional)',
              hint: 'Tolong dikemas rapi',
              maxLines: 2,
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        color: Colors.white,
        child: Obx(() => FilledButton(
              onPressed:
                  controller.isCheckingOut.value ? null : controller.checkout,
              style: FilledButton.styleFrom(
                backgroundColor: kBlue,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
              ),
              child: controller.isCheckingOut.value
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: Colors.white))
                  : const Text('Bayar Sekarang',
                      style:
                          TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
            )),
      ),
    );
  }

  Widget _sectionTitle(String title) => Text(title,
      style: const TextStyle(
          fontSize: 16, fontWeight: FontWeight.w800, color: kNavy));

  Widget _inputField({
    required TextEditingController controller,
    required String label,
    required String hint,
    int maxLines = 1,
    TextInputType? keyboardType,
  }) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: const TextStyle(
                  fontWeight: FontWeight.w700, color: kNavy, fontSize: 13)),
          const SizedBox(height: 6),
          TextField(
            controller: controller,
            maxLines: maxLines,
            keyboardType: keyboardType,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(color: Colors.blueGrey.shade400),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
          ),
        ],
      );

  String _formatHarga(double harga) =>
      harga.toStringAsFixed(0).replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.');
}
