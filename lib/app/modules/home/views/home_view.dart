import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ujikom_project/app/models/catatan_model.dart';
import 'package:ujikom_project/app/modules/home/controllers/home_controller.dart';
import 'package:ujikom_project/app/modules/home/views/catatan_detail_view.dart';
import 'package:ujikom_project/app/modules/home/views/jadwal_view.dart';
import 'package:ujikom_project/app/modules/toko/view/obat_list_view.dart';
import 'package:ujikom_project/app/modules/toko/view/riwayat_view.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  static const kNavy = Color(0xFF0C1D3B);
  static const kBlue = Color(0xFF1A56DB);
  static const kBg = Color(0xFFF0F5FF);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();

    return Scaffold(
      backgroundColor: kBg,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final contentWidth =
                constraints.maxWidth > 900 ? 900.0 : double.infinity;

            return Column(
              children: [
                _buildHeader(controller, contentWidth),
                Expanded(
                  child: RefreshIndicator(
                    color: kBlue,
                    onRefresh: controller.refreshAll,
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(16),
                      child: Center(
                        child: ConstrainedBox(
                          constraints: BoxConstraints(maxWidth: contentWidth),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _sectionTitle('Layanan'),
                              const SizedBox(height: 12),
                              _buildLayananGrid(controller, contentWidth),
                              const SizedBox(height: 24),
                              _sectionTitle('Jadwal Hari Ini'),
                              const SizedBox(height: 12),
                              _buildJadwalSection(controller),
                              const SizedBox(height: 24),
                              _sectionTitle('Catatan Terbaru'),
                              const SizedBox(height: 12),
                              _buildCatatanSection(controller),
                              const SizedBox(height: 24),
                              _sectionHeader(
                                'Riwayat Pembelian',
                                onTap: () => Get.to(
                                  () => const RiwayatView(),
                                  transition: Transition.rightToLeft,
                                ),
                              ),
                              const SizedBox(height: 12),
                              _buildRiwayatSection(controller),
                              const SizedBox(height: 24),
                              _sectionTitle('Info Kesehatan'),
                              const SizedBox(height: 12),
                              _buildInfoSection(controller),
                              const SizedBox(height: 24),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
      bottomNavigationBar: _buildNavBar(),
    );
  }

  // ===================== HEADER =====================
  Widget _buildHeader(HomeController controller, double contentWidth) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
      decoration: const BoxDecoration(
        color: kBlue,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(28)),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: contentWidth),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Selamat pagi,',
                          style: TextStyle(fontSize: 13, color: Colors.white70),
                        ),
                        Obx(() => Text(
                              controller.userName.value.isEmpty
                                  ? 'Pengguna'
                                  : controller.userName.value,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            )),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Obx(() {
                    final name = controller.userName.value.trim();
                    final initials = name.isNotEmpty
                        ? name
                            .split(' ')
                            .where((e) => e.isNotEmpty)
                            .take(2)
                            .map((e) => e[0])
                            .join()
                        : 'U';
                    return CircleAvatar(
                      radius: 21,
                      backgroundColor: Colors.white24,
                      child: Text(
                        initials.toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    );
                  }),
                  const SizedBox(width: 4),
                  IconButton(
                    onPressed: _confirmLogout,
                    icon: const Icon(
                      Icons.logout_rounded,
                      color: Colors.white70,
                    ),
                    tooltip: 'Logout',
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Obx(() => controller.kodePasien.value.isNotEmpty
                  ? Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.18),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        'Kode: ${controller.kodePasien.value}',
                        style:
                            const TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    )
                  : const SizedBox.shrink()),
              const SizedBox(height: 14),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: TextField(
                  onChanged: controller.updateSearch,
                  decoration: const InputDecoration(
                    hintText: 'Cari layanan...',
                    border: InputBorder.none,
                    prefixIcon: Icon(Icons.search),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ===================== LAYANAN GRID =====================
  Widget _buildLayananGrid(HomeController controller, double maxWidth) {
    final crossAxisCount = maxWidth >= 720 ? 4 : 2;
    final childAspectRatio = maxWidth >= 720 ? 1.35 : 1.1;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: childAspectRatio,
      ),
      itemCount: controller.layananList.length,
      itemBuilder: (_, i) {
        final item = controller.layananList[i];
        return _LayananCard(
          title: item['title'] as String,
          subtitle: item['subtitle'] as String,
          onTap: () => _handleLayananTap(i, controller),
        );
      },
    );
  }

  // ===================== JADWAL =====================
  Widget _buildJadwalSection(HomeController controller) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (controller.errorMessage.value.isNotEmpty) {
        return _errorBox(controller.errorMessage.value);
      }

      if (controller.jadwalList.isEmpty) {
        return _emptyState(
          icon: Icons.calendar_month_outlined,
          title: 'Belum ada jadwal',
          subtitle: 'Jadwal obat kamu akan muncul di sini.',
        );
      }

      final list = controller.jadwalList.take(3).toList();
      return Column(
        children: [
          ...list.map((j) => Card(
                margin: const EdgeInsets.only(bottom: 8),
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  onTap: () => Get.to(
                    () => JadwalView(),
                    transition: Transition.rightToLeft,
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  leading: const CircleAvatar(
                    backgroundColor: Color(0xFFE8F0FF),
                    child: Icon(Icons.medication_outlined, color: kBlue),
                  ),
                  title: Text(j.namaObat,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: Text(
                    j.waktuObat.isNotEmpty
                        ? j.waktuObat.join(', ')
                        : 'Jadwal tersedia',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: const Icon(Icons.chevron_right),
                ),
              )),
          if (controller.jadwalList.length > 3)
            TextButton(
              onPressed: () => Get.to(
                () => JadwalView(),
                transition: Transition.rightToLeft,
              ),
              child: const Text('Lihat semua jadwal →'),
            ),
        ],
      );
    });
  }

  // ===================== CATATAN =====================
  Widget _buildCatatanSection(HomeController controller) {
    return Obx(() {
      if (controller.catatanErrorMessage.value.isNotEmpty) {
        return _errorBox(controller.catatanErrorMessage.value);
      }

      if (controller.catatanList.isEmpty) {
        return _emptyState(
          icon: Icons.note_alt_outlined,
          title: 'Belum ada catatan',
          subtitle: 'Catatan kondisi kesehatan kamu akan muncul di sini.',
        );
      }

      final list = controller.catatanList.take(3).toList();
      return Column(
        children: [
          ...list.map((c) => Card(
                margin: const EdgeInsets.only(bottom: 8),
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  onTap: () => Get.to(
                    () => CatatanDetailView(catatan: c),
                    transition: Transition.rightToLeft,
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  leading: const CircleAvatar(
                    backgroundColor: Color(0xFFE8F0FF),
                    child: Icon(Icons.note_alt_outlined, color: kBlue),
                  ),
                  title: Text(c.diagnosa,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: Text('dr. ${c.namaDokter}',
                      maxLines: 1, overflow: TextOverflow.ellipsis),
                  trailing: const Icon(Icons.chevron_right),
                ),
              )),
          if (controller.catatanList.length > 3)
            TextButton(
              onPressed: () => _showCatatanList(controller.catatanList),
              child: const Text('Lihat semua catatan →'),
            ),
        ],
      );
    });
  }

  // ===================== RIWAYAT PEMBELIAN =====================
  Widget _buildRiwayatSection(HomeController controller) {
    return Obx(() {
      if (controller.isLoadingRiwayat.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (controller.riwayatErrorMessage.value.isNotEmpty) {
        return _errorBox(controller.riwayatErrorMessage.value);
      }

      if (controller.riwayatList.isEmpty) {
        return _emptyState(
          icon: Icons.receipt_long_outlined,
          title: 'Belum ada riwayat',
          subtitle: 'Riwayat pembelian obat kamu akan muncul di sini.',
        );
      }

      final list = controller.riwayatList.take(3).toList();
      return Column(
        children: [
          ...list.map((t) {
            final statusColor = _statusColor(t.status);
            return Card(
              margin: const EdgeInsets.only(bottom: 8),
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                onTap: () => Get.to(
                  () => const RiwayatView(),
                  transition: Transition.rightToLeft,
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                leading: const CircleAvatar(
                  backgroundColor: Color(0xFFE8F0FF),
                  child: Icon(Icons.receipt_long_outlined, color: kBlue),
                ),
                title: Text(
                  t.kodeTransaksi,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                subtitle: Text(
                  '${t.items.length} item · ${t.createdAt.substring(0, 10)}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    t.status.toUpperCase(),
                    style: TextStyle(
                      color: statusColor,
                      fontWeight: FontWeight.w700,
                      fontSize: 11,
                    ),
                  ),
                ),
              ),
            );
          }),
          if (controller.riwayatList.length > 3)
            TextButton(
              onPressed: () => Get.to(
                () => const RiwayatView(),
                transition: Transition.rightToLeft,
              ),
              child: const Text('Lihat semua riwayat →'),
            ),
        ],
      );
    });
  }

  // ===================== INFO =====================
  Widget _buildInfoSection(HomeController controller) {
    return SizedBox(
      height: 140,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: controller.infoList.length,
        itemBuilder: (_, i) {
          final info = controller.infoList[i];
          return Container(
            width: 220,
            margin: const EdgeInsets.only(right: 10),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(info['title'] ?? '',
                    style: const TextStyle(
                        fontWeight: FontWeight.w700, fontSize: 13)),
                const SizedBox(height: 6),
                Text(info['description'] ?? '',
                    style: const TextStyle(fontSize: 11, color: Colors.grey),
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis),
              ],
            ),
          );
        },
      ),
    );
  }

  // ===================== NAVBAR =====================
  Widget _buildNavBar() => const SizedBox(height: 60);

  // ===================== HELPERS =====================
  Widget _sectionTitle(String title) => Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: kNavy,
        ),
      );

  Widget _sectionHeader(String title, {VoidCallback? onTap}) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style: const TextStyle(
                  fontSize: 16, fontWeight: FontWeight.w700, color: kNavy)),
          if (onTap != null)
            GestureDetector(
              onTap: onTap,
              child: const Text('Lihat semua',
                  style: TextStyle(
                      fontSize: 13, color: kBlue, fontWeight: FontWeight.w600)),
            ),
        ],
      );

  Widget _errorBox(String message) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFFFF2F2),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(message, style: const TextStyle(color: Colors.red)),
      );

  Widget _emptyState({
    required IconData icon,
    required String title,
    required String subtitle,
  }) =>
      Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 36, color: kBlue),
            const SizedBox(height: 12),
            Text(title,
                style: const TextStyle(
                    fontSize: 16, fontWeight: FontWeight.w700, color: kNavy)),
            const SizedBox(height: 6),
            Text(subtitle,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.grey)),
          ],
        ),
      );

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

  void _confirmLogout() {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Keluar?',
            style: TextStyle(fontWeight: FontWeight.w700)),
        content: const Text('Kamu yakin ingin keluar dari akun ini?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: kBlue,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () {
              Get.back();
              Get.find<HomeController>().logout();
            },
            child: const Text('Keluar'),
          ),
        ],
      ),
    );
  }

  void _handleLayananTap(int index, HomeController controller) {
    switch (index) {
      case 0:
        Get.to(() => JadwalView(), transition: Transition.rightToLeft);
        break;
      case 1:
        _showCatatanList(controller.catatanList);
        break;
      case 2:
        Get.snackbar('Notifikasi',
            'Jumlah notifikasi aktif dihitung dari jadwal yang punya pengingat.');
        break;
      case 3:
        Get.to(() => const ObatListView(), transition: Transition.rightToLeft);
        break;
    }
  }

  void _showCatatanList(List<CatatanModel> list) {
    if (list.isEmpty) {
      Get.snackbar('Catatan', 'Belum ada catatan tersedia.');
      return;
    }

    Get.bottomSheet(
      Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.black12,
                borderRadius: BorderRadius.circular(99),
              ),
            ),
            const SizedBox(height: 16),
            const Text('Semua Catatan',
                style: TextStyle(
                    fontSize: 16, fontWeight: FontWeight.w800, color: kNavy)),
            const SizedBox(height: 12),
            Flexible(
              child: ListView.separated(
                shrinkWrap: true,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                itemCount: list.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (_, i) {
                  final c = list[i];
                  return ListTile(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    tileColor: const Color(0xFFF4F7FF),
                    onTap: () {
                      Get.back();
                      Get.to(
                        () => CatatanDetailView(catatan: c),
                        transition: Transition.rightToLeft,
                      );
                    },
                    leading: const CircleAvatar(
                      backgroundColor: Color(0xFFE8F0FF),
                      child: Icon(Icons.note_alt_outlined, color: kBlue),
                    ),
                    title: Text(c.diagnosa,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.w600)),
                    subtitle: Text('dr. ${c.namaDokter}'),
                    trailing: const Icon(Icons.chevron_right),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }
}

// ======================================================
// ✅ Widget terpisah — Obx aman karena punya build() sendiri
// ======================================================
class _LayananCard extends StatelessWidget {
  const _LayananCard({
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  static const kBlue = Color(0xFF1A56DB);
  static const kNavy = Color(0xFF0C1D3B);

  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();
    final isToko = title == 'Toko';

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(_layananIcon(title), color: kBlue, size: 26),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontWeight: FontWeight.w700, fontSize: 14)),
                const SizedBox(height: 2),
                Text(subtitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 11, color: Colors.grey)),
              ],
            ),
            isToko
                ? const Text('Buka',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: kBlue))
                : Obx(() => Text(
                      _layananCount(title, controller),
                      style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: kBlue),
                    )),
          ],
        ),
      ),
    );
  }

  IconData _layananIcon(String title) {
    switch (title) {
      case 'Jadwal':
        return Icons.calendar_month_outlined;
      case 'Catatan':
        return Icons.note_alt_outlined;
      case 'Notifikasi':
        return Icons.notifications_active_outlined;
      case 'Toko':
        return Icons.shopping_bag_outlined;
      default:
        return Icons.apps_outlined;
    }
  }

  String _layananCount(String title, HomeController controller) {
    switch (title) {
      case 'Jadwal':
        return controller.jadwalList.length.toString();
      case 'Catatan':
        return controller.catatanList.length.toString();
      case 'Notifikasi':
        return controller.totalNotifikasiAktif.toString();
      default:
        return '';
    }
  }
}
