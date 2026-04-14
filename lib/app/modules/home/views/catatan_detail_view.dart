import 'package:flutter/material.dart';
import 'package:ujikom_project/app/models/catatan_model.dart';

class CatatanDetailView extends StatelessWidget {
  const CatatanDetailView({super.key, required this.catatan});

  final CatatanModel catatan;

  static const kNavy = Color(0xFF0C1D3B);
  static const kBlue = Color(0xFF1A56DB);
  static const kBg = Color(0xFFF4F7FF);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: kNavy,
        elevation: 0,
        title: const Text('Detail Catatan'),
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
                Text(
                  catatan.diagnosa,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'dr. ${catatan.namaDokter}',
                  style: TextStyle(color: Colors.white.withValues(alpha: 0.78), fontSize: 14),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          _detailCard(
            title: 'Informasi Catatan',
            children: [
              _infoTile('Tanggal Catatan', catatan.tanggalCatatan),
              _infoTile('Pasien', catatan.namaPasien),
              _infoTile('Kode Pasien', catatan.kodePasien),
            ],
          ),
          const SizedBox(height: 18),
          _detailCard(
            title: 'Keluhan',
            children: [
              Text(
                catatan.keluhan,
                style: const TextStyle(color: Colors.black54, height: 1.55),
              ),
            ],
          ),
          if (catatan.deskripsi.isNotEmpty) ...[
            const SizedBox(height: 18),
            _detailCard(
              title: 'Deskripsi',
              children: [
                Text(
                  catatan.deskripsi,
                  style: const TextStyle(color: Colors.black54, height: 1.55),
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

