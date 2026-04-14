import 'package:flutter/material.dart';
import 'package:ujikom_project/app/models/jadwal_model.dart';

class JadwalDetailView extends StatelessWidget {
  const JadwalDetailView({super.key, required this.jadwal});

  final JadwalModel jadwal;

  static const kNavy = Color(0xFF0C1D3B);
  static const kBlue = Color(0xFF1A56DB);
  static const kBg = Color(0xFFF4F7FF);

  @override
  Widget build(BuildContext context) {
    final isAktif = jadwal.status.toLowerCase() == 'aktif';

    return Scaffold(
      backgroundColor: kBg,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: kNavy,
        elevation: 0,
        title: const Text('Detail Jadwal'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF0C1D3B), Color(0xFF173269)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        jadwal.namaObat,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                      decoration: BoxDecoration(
                        color: isAktif ? const Color(0xFFDCFCE7) : const Color(0xFFFEE2E2),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        jadwal.status,
                        style: TextStyle(
                          color: isAktif ? const Color(0xFF166534) : const Color(0xFF991B1B),
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  'dr. ${jadwal.namaDokter}',
                  style: TextStyle(color: Colors.white.withValues(alpha: 0.78), fontSize: 14),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          _detailCard(
            title: 'Informasi Jadwal',
            children: [
              _infoTile('Spesialisasi', jadwal.spesialisasiDokter),
              _infoTile('Periode', '${jadwal.tanggalMulai} - ${jadwal.tanggalSelesai}'),
              _infoTile('Pengingat', jadwal.statusPengingat ? 'Aktif' : 'Tidak aktif'),
            ],
          ),
          if (jadwal.deskripsi.isNotEmpty) ...[
            const SizedBox(height: 18),
            _detailCard(
              title: 'Deskripsi',
              children: [
                Text(
                  jadwal.deskripsi,
                  style: const TextStyle(color: Colors.black54, height: 1.55),
                ),
              ],
            ),
          ],
          if (jadwal.waktuObat.isNotEmpty) ...[
            const SizedBox(height: 18),
            _detailCard(
              title: 'Waktu Minum',
              children: [
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: jadwal.waktuObat
                      .map(
                        (time) => Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEAF1FF),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            time,
                            style: const TextStyle(color: kBlue, fontWeight: FontWeight.w700),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _detailCard({required String title, required List<Widget> children}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: const [
          BoxShadow(
            color: Color(0x10000000),
            blurRadius: 16,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: kNavy),
          ),
          const SizedBox(height: 14),
          ...children,
        ],
      ),
    );
  }

  Widget _infoTile(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(color: Colors.black45, fontSize: 12, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 5),
          Text(
            value,
            style: const TextStyle(color: kNavy, fontSize: 15, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
