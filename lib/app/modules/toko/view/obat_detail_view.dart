import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ujikom_project/app/models/obat_model.dart';
import 'package:ujikom_project/app/modules/toko/controllers/toko_controller.dart';
import 'checkout_view.dart';

class ObatDetailView extends StatelessWidget {
  const ObatDetailView({super.key, required this.obat});
  final ObatModel obat;

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
        title: Text(obat.namaObat,
            style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Foto
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: obat.fotoUrl.isNotEmpty
                  ? Image.network(obat.fotoUrl,
                      height: 220,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => _placeholder())
                  : _placeholder(),
            ),
            const SizedBox(height: 20),

            // Info utama
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(obat.namaObat,
                      style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: kNavy)),
                  const SizedBox(height: 8),
                  Row(children: [
                    Text('Rp ${_formatHarga(obat.harga)}/${obat.satuan}',
                        style: const TextStyle(
                            color: kBlue,
                            fontWeight: FontWeight.w800,
                            fontSize: 18)),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: const Color(0xFFDCFCE7),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text('Stok: ${obat.stok}',
                          style: const TextStyle(
                              color: Color(0xFF166534),
                              fontWeight: FontWeight.w700,
                              fontSize: 12)),
                    ),
                  ]),
                ],
              ),
            ),
            const SizedBox(height: 14),

            _infoCard('Deskripsi', obat.deskripsi),
            const SizedBox(height: 14),
            _infoCard('Aturan Pakai', obat.aturanPakai),
            const SizedBox(height: 14),
            _infoCard('Efek Samping', obat.efekSamping),
            const SizedBox(height: 80),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        color: Colors.white,
        child: Obx(() {
          final jumlah = controller.jumlahDiKeranjang(obat.id);
          return Row(
            children: [
              if (jumlah > 0) ...[
                _qtyBtn(Icons.remove_rounded,
                    () => controller.kurangKeranjang(obat.id)),
                const SizedBox(width: 12),
                Text('$jumlah',
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: kNavy)),
                const SizedBox(width: 12),
                _qtyBtn(Icons.add_rounded,
                    () => controller.tambahKeranjang(obat.id)),
                const SizedBox(width: 14),
              ],
              Expanded(
                child: FilledButton(
                  onPressed: jumlah > 0
                      ? () => Get.to(() => const CheckoutView())
                      : () => controller.tambahKeranjang(obat.id),
                  style: FilledButton.styleFrom(
                    backgroundColor: kBlue,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                  ),
                  child: Text(
                    jumlah > 0 ? 'Checkout Sekarang' : '+ Tambah ke Keranjang',
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _infoCard(String title, String content) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: const TextStyle(
                    fontWeight: FontWeight.w800, color: kNavy, fontSize: 15)),
            const SizedBox(height: 8),
            Text(content,
                style: TextStyle(color: Colors.blueGrey.shade600, height: 1.5)),
          ],
        ),
      );

  Widget _placeholder() => Container(
        height: 220,
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color(0xFFEAF1FF),
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Icon(Icons.medication_rounded, color: kBlue, size: 60),
      );

  Widget _qtyBtn(IconData icon, VoidCallback onTap) => GestureDetector(
        onTap: onTap,
        child: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: const Color(0xFFEAF1FF),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: kBlue),
        ),
      );

  String _formatHarga(double harga) =>
      harga.toStringAsFixed(0).replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.');
}
