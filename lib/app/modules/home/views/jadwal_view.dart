import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ujikom_project/app/models/jadwal_model.dart';
import 'package:ujikom_project/app/modules/home/controllers/jadwal_controller.dart';
import 'package:ujikom_project/app/modules/home/views/jadwal_detail_view.dart';

class JadwalView extends StatelessWidget {
  const JadwalView({super.key});

  static const kNavy = Color(0xFF0C1D3B);
  static const kBlue = Color(0xFF1A56DB);
  static const kBg = Color(0xFFF4F7FF);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(JadwalController());

    return Scaffold(
      backgroundColor: kBg,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: kNavy,
        elevation: 0,
        title: const Text(
          'Jadwal Obat',
          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
        ),
        actions: [
          Obx(
            () => controller.isLoading.value
                ? const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Center(
                      child: SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    ),
                  )
                : IconButton(
                    icon: const Icon(Icons.refresh_rounded),
                    onPressed: controller.refresh,
                  ),
          ),
        ],
      ),
      body: Column(
        children: [
          _FilterBar(controller: controller),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(
                    child: CircularProgressIndicator(color: kBlue));
              }

              if (controller.errorMessage.isNotEmpty) {
                return _ErrorState(
                  message: controller.errorMessage.value,
                  onRetry: controller.refresh,
                );
              }

              final list = controller.filteredList;
              if (list.isEmpty) return const _EmptyState();

              return RefreshIndicator(
                color: kBlue,
                onRefresh: controller.fetchJadwal,
                child: ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                  itemCount: list.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (_, i) => _JadwalCard(jadwal: list[i]),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

// ─── Filter Bar ───────────────────────────────────────────────────────────────

class _FilterBar extends StatelessWidget {
  const _FilterBar({required this.controller});
  final JadwalController controller;

  static const _options = ['semua', 'aktif', 'nonaktif'];
  static const _labels = ['Semua', 'Aktif', 'Nonaktif'];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: Obx(
        () => Row(
          children: List.generate(_options.length, (i) {
            final selected = controller.filterStatus.value == _options[i];
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: GestureDetector(
                onTap: () => controller.setFilter(_options[i]),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                  decoration: BoxDecoration(
                    color:
                        selected ? JadwalView.kBlue : const Color(0xFFF0F3FF),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    _labels[i],
                    style: TextStyle(
                      color: selected ? Colors.white : JadwalView.kNavy,
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}

// ─── Jadwal Card ──────────────────────────────────────────────────────────────

class _JadwalCard extends StatelessWidget {
  const _JadwalCard({required this.jadwal});
  final JadwalModel jadwal;

  @override
  Widget build(BuildContext context) {
    final isAktif = jadwal.status.toLowerCase() == 'aktif';

    return GestureDetector(
      onTap: () => Get.to(
        () => JadwalDetailView(jadwal: jadwal),
        transition: Transition.rightToLeft,
      ),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
                color: Color(0x10000000), blurRadius: 14, offset: Offset(0, 4)),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: const Color(0xFFEAF1FF),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(Icons.medication_rounded,
                  color: JadwalView.kBlue, size: 26),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          jadwal.namaObat,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: JadwalView.kNavy,
                          ),
                        ),
                      ),
                      _StatusBadge(isAktif: isAktif, label: jadwal.status),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'dr. ${jadwal.namaDokter}',
                    style: const TextStyle(
                      color: Colors.black45,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.calendar_today_rounded,
                          size: 13, color: Colors.black38),
                      const SizedBox(width: 4),
                      Text(
                        '${jadwal.tanggalMulai} – ${jadwal.tanggalSelesai}',
                        style: const TextStyle(
                            color: Colors.black45, fontSize: 11),
                      ),
                    ],
                  ),
                  if (jadwal.waktuObat.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: jadwal.waktuObat
                          .take(3)
                          .map(
                            (t) => Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 9, vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color(0xFFEAF1FF),
                                borderRadius: BorderRadius.circular(999),
                              ),
                              child: Text(
                                t,
                                style: const TextStyle(
                                  color: JadwalView.kBlue,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 4),
            const Icon(Icons.chevron_right_rounded,
                color: Colors.black26, size: 22),
          ],
        ),
      ),
    );
  }
}

// ─── Status Badge ─────────────────────────────────────────────────────────────

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.isAktif, required this.label});
  final bool isAktif;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isAktif ? const Color(0xFFDCFCE7) : const Color(0xFFFEE2E2),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isAktif ? const Color(0xFF166534) : const Color(0xFF991B1B),
          fontWeight: FontWeight.w700,
          fontSize: 11,
        ),
      ),
    );
  }
}

// ─── Empty State ──────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: const Color(0xFFEAF1FF),
              borderRadius: BorderRadius.circular(24),
            ),
            child: const Icon(Icons.event_note_rounded,
                size: 40, color: JadwalView.kBlue),
          ),
          const SizedBox(height: 16),
          const Text(
            'Belum ada jadwal',
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: JadwalView.kNavy),
          ),
          const SizedBox(height: 6),
          const Text(
            'Jadwal obat kamu akan muncul di sini.',
            style: TextStyle(color: Colors.black45, fontSize: 13),
          ),
        ],
      ),
    );
  }
}

// ─── Error State ──────────────────────────────────────────────────────────────

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.message, required this.onRetry});
  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.wifi_off_rounded, size: 48, color: Colors.black26),
            const SizedBox(height: 14),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.black45, fontSize: 13),
            ),
            const SizedBox(height: 18),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded, size: 18),
              label: const Text('Coba Lagi'),
              style: ElevatedButton.styleFrom(
                backgroundColor: JadwalView.kBlue,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(999)),
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
