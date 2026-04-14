class ObatModel {
  final int id;
  final String kodeObat;
  final String namaObat;
  final String deskripsi;
  final String aturanPakai;
  final String efekSamping;
  final int stok;
  final double harga;
  final String satuan;
  final String fotoUrl;

  ObatModel({
    required this.id,
    required this.kodeObat,
    required this.namaObat,
    required this.deskripsi,
    required this.aturanPakai,
    required this.efekSamping,
    required this.stok,
    required this.harga,
    required this.satuan,
    required this.fotoUrl,
  });

  factory ObatModel.fromJson(Map<String, dynamic> json) {
    return ObatModel(
      id: json['id'] as int? ?? 0,
      kodeObat: json['kode_obat'] as String? ?? '',
      namaObat: json['nama_obat'] as String? ?? '',
      deskripsi: json['deskripsi'] as String? ?? '',
      aturanPakai: json['aturan_pakai'] as String? ?? '',
      efekSamping: json['efek_samping'] as String? ?? '',
      stok: json['stok'] as int? ?? 0,
      harga: (json['harga'] as num?)?.toDouble() ?? 0,
      satuan: json['satuan'] as String? ?? '',
      fotoUrl: json['foto_url'] as String? ?? '',
    );
  }
}
