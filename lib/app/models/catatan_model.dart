class CatatanModel {
  CatatanModel({
    required this.id,
    required this.diagnosa,
    required this.keluhan,
    required this.deskripsi,
    required this.tanggalCatatan,
    required this.namaDokter,
    required this.namaPasien,
    required this.kodePasien,
  });

  final int id;
  final String diagnosa;
  final String keluhan;
  final String deskripsi;
  final String tanggalCatatan;
  final String namaDokter;
  final String namaPasien;
  final String kodePasien;

  factory CatatanModel.fromJson(Map<String, dynamic> json) {
    final dokter = (json['dokter'] as Map<String, dynamic>?) ?? const {};
    final pasien = (json['pasien'] as Map<String, dynamic>?) ?? const {};

    return CatatanModel(
      id: json['id'] is int ? json['id'] as int : int.tryParse('${json['id']}') ?? 0,
      diagnosa: '${json['diagnosa'] ?? '-'}',
      keluhan: '${json['keluhan'] ?? '-'}',
      deskripsi: '${json['deskripsi'] ?? ''}',
      tanggalCatatan: '${json['tanggal_catatan'] ?? '-'}',
      namaDokter: '${dokter['nama'] ?? 'Dokter belum tersedia'}',
      namaPasien: '${pasien['name'] ?? 'Pasien'}',
      kodePasien: '${pasien['kode_pasien'] ?? '-'}',
    );
  }
}
