import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ujikom_project/app/models/obat_model.dart';
import 'package:ujikom_project/app/modules/toko/controllers/toko_controller.dart';
import 'package:ujikom_project/app/modules/toko/view/checkout_view.dart';
import 'package:ujikom_project/app/modules/toko/view/obat_detail_view.dart';
import 'package:ujikom_project/app/modules/toko/view/riwayat_view.dart';

class ObatListView extends StatelessWidget {
  const ObatListView({super.key});

  static const kNavy = Color(0xFF0C1D3B);
  static const kBlue = Color(0xFF1A56DB);
  static const kBg = Color(0xFFF4F7FF);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(TokoController());

    return Scaffold(
      backgroundColor: kBg,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: kNavy,
        elevation: 0,
        title: const Text(
          'Beli Obat',
          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
        ),
        actions: [
          // ✅ Tidak perlu Obx — tidak ada variabel .obs yang dibaca
          IconButton(
            icon: const Icon(Icons.receipt_long_rounded),
            onPressed: () => Get.to(() => const RiwayatView()),
          ),
          // ✅ Obx hanya di cart badge karena membaca totalItemKeranjang (.obs)
          Obx(() {
            final total = controller.totalItemKeranjang;
            return Stack(
              alignment: Alignment.topRight,
              children: [
                IconButton(
                  icon: const Icon(Icons.shopping_cart_rounded),
                  onPressed: total > 0
                      ? () => Get.to(() => const CheckoutView())
                      : null,
                ),
                if (total > 0)
                  Positioned(
                    right: 6,
                    top: 6,
                    child: Container(
                      width: 16,
                      height: 16,
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          '$total',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            );
          }),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: TextField(
              onChanged: controller.onSearch,
              decoration: InputDecoration(
                hintText: 'Cari obat...',
                hintStyle: TextStyle(color: Colors.blueGrey.shade400),
                prefixIcon: const Icon(Icons.search_rounded, color: kBlue),
                filled: true,
                fillColor: kBg,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
              ),
            ),
          ),

          // List
          Expanded(
            child: Obx(() {
              if (controller.isLoadingObat.value) {
                return const Center(
                    child: CircularProgressIndicator(color: kBlue));
              }

              if (controller.obatError.value.isNotEmpty) {
                return Center(
                  child: Text(
                    controller.obatError.value,
                    style: const TextStyle(color: Colors.black45),
                  ),
                );
              }

              if (controller.obatList.isEmpty) {
                return const Center(child: Text('Tidak ada obat tersedia'));
              }

              return RefreshIndicator(
                color: kBlue,
                onRefresh: controller.fetchObat,
                child: GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisExtent: 230,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemCount: controller.obatList.length,
                  itemBuilder: (_, i) =>
                      _ObatCard(obat: controller.obatList[i]),
                ),
              );
            }),
          ),
        ],
      ),

      // Tombol checkout
      bottomNavigationBar: Obx(() => controller.totalItemKeranjang > 0
          ? Container(
              padding: const EdgeInsets.all(16),
              color: Colors.white,
              child: FilledButton(
                onPressed: () => Get.to(() => const CheckoutView()),
                style: FilledButton.styleFrom(
                  backgroundColor: kBlue,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                ),
                child: Text(
                  'Keranjang (${controller.totalItemKeranjang}) · Rp ${_formatHarga(controller.totalHargaKeranjang)}',
                  style: const TextStyle(
                      fontWeight: FontWeight.w700, fontSize: 15),
                ),
              ),
            )
          : const SizedBox.shrink()),
    );
  }

  String _formatHarga(double harga) {
    return harga.toStringAsFixed(0).replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.');
  }
}

class _ObatCard extends StatelessWidget {
  const _ObatCard({required this.obat});
  final ObatModel obat;

  static const kNavy = Color(0xFF0C1D3B);
  static const kBlue = Color(0xFF1A56DB);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TokoController>();

    return GestureDetector(
      onTap: () => Get.to(() => ObatDetailView(obat: obat)),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
                color: Color(0x10000000),
                blurRadius: 14,
                offset: Offset(0, 4)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Foto
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(20)),
              child: obat.fotoUrl.isNotEmpty
                  ? Image.network(
                      obat.fotoUrl,
                      height: 110,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => _placeholder(),
                    )
                  : _placeholder(),
            ),

            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    obat.namaObat,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                        color: kNavy),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Rp ${_formatHarga(obat.harga)}/${obat.satuan}',
                    style: const TextStyle(
                        color: kBlue,
                        fontWeight: FontWeight.w800,
                        fontSize: 13),
                  ),
                  const SizedBox(height: 8),
                  Obx(() {
                    final jumlah = controller.jumlahDiKeranjang(obat.id);
                    if (jumlah == 0) {
                      return SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: () => controller.tambahKeranjang(obat.id),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: kBlue,
                            side: const BorderSide(color: kBlue),
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                          ),
                          child: const Text(
                            '+ Keranjang',
                            style: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.w700),
                          ),
                        ),
                      );
                    }

                    return Row(
                      children: [
                        _qtyBtn(Icons.remove_rounded,
                            () => controller.kurangKeranjang(obat.id)),
                        Expanded(
                          child: Center(
                            child: Text(
                              '$jumlah',
                              style: const TextStyle(
                                  fontWeight: FontWeight.w800, color: kNavy),
                            ),
                          ),
                        ),
                        _qtyBtn(Icons.add_rounded,
                            () => controller.tambahKeranjang(obat.id)),
                      ],
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _placeholder() => Container(
        height: 110,
        width: double.infinity,
        color: const Color(0xFFEAF1FF),
        child: const Icon(Icons.medication_rounded, color: kBlue, size: 40),
      );

  Widget _qtyBtn(IconData icon, VoidCallback onTap) => GestureDetector(
        onTap: onTap,
        child: Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: const Color(0xFFEAF1FF),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 16, color: kBlue),
        ),
      );

  String _formatHarga(double harga) =>
      harga.toStringAsFixed(0).replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.');
}