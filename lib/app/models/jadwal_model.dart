class JadwalModel {
  JadwalModel({
    required this.id,
    required this.namaObat,
    required this.deskripsi,
    required this.tanggalMulai,
    required this.tanggalSelesai,
    required this.status,
    required this.statusPengingat,
    required this.namaDokter,
    required this.spesialisasiDokter,
    required this.waktuObat,
  });

  final int id;
  final String namaObat;
  final String deskripsi;
  final String tanggalMulai;
  final String tanggalSelesai;
  final String status;
  final bool statusPengingat;
  final String namaDokter;
  final String spesialisasiDokter;
  final List<String> waktuObat;

  factory JadwalModel.fromJson(Map<String, dynamic> json) {
    final dokter = (json['dokter'] as Map<String, dynamic>?) ?? {};
    final spesialisasi =
        (dokter['spesialisasi'] as Map<String, dynamic>?) ?? const {};
    final waktuList = json['waktu_obat'] ?? json['waktuObat'] ?? [];

    return JadwalModel(
      id: json['id'] is int ? json['id'] as int : int.tryParse('${json['id']}') ?? 0,
      namaObat: '${json['nama_obat'] ?? '-'}',
      deskripsi: '${json['deskripsi'] ?? ''}',
      tanggalMulai: '${json['tanggal_mulai'] ?? '-'}',
      tanggalSelesai: '${json['tanggal_selesai'] ?? '-'}',
      status: '${json['status'] ?? 'Belum ada status'}',
      statusPengingat: json['status_pengingat'] == true,
      namaDokter: '${dokter['nama'] ?? 'Dokter belum tersedia'}',
      spesialisasiDokter:
          '${spesialisasi['nama_spesialisasi'] ?? spesialisasi['nama'] ?? 'Spesialisasi belum tersedia'}',
      waktuObat: (waktuList as List)
          .map((item) {
            if (item is Map<String, dynamic>) {
              return '${item['waktu'] ?? item['jam'] ?? item['nama_waktu'] ?? '-'}';
            }
            return '$item';
          })
          .where((item) => item != '-')
          .toList(),
    );
  }
}
