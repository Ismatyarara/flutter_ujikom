class TransaksiItemModel {
  final int id;
  final String namaObat;
  final String fotoUrl;
  final int jumlah;
  final double hargaSatuan;
  final double subtotal;

  TransaksiItemModel({
    required this.id,
    required this.namaObat,
    required this.fotoUrl,
    required this.jumlah,
    required this.hargaSatuan,
    required this.subtotal,
  });

  factory TransaksiItemModel.fromJson(Map<String, dynamic> json) =>
      TransaksiItemModel(
        id: json['id'] ?? 0,
        namaObat: json['nama_obat'] ?? '',
        fotoUrl: json['foto_url'] ?? '',
        jumlah: json['jumlah'] ?? 0,
        hargaSatuan: _toDouble(json['harga_satuan']),
        subtotal: _toDouble(json['subtotal']),
      );
}

class TransaksiModel {
  final int id;
  final String kodeTransaksi;
  final String status;
  final double totalHarga;
  final String snapToken;
  final String alamatPengiriman;
  final String noTelepon;
  final String catatan;
  final String? tanggalBayar;
  final String createdAt;
  final List<TransaksiItemModel> items;

  TransaksiModel({
    required this.id,
    required this.kodeTransaksi,
    required this.status,
    required this.totalHarga,
    required this.snapToken,
    required this.alamatPengiriman,
    required this.noTelepon,
    required this.catatan,
    this.tanggalBayar,
    required this.createdAt,
    required this.items,
  });

  factory TransaksiModel.fromJson(Map<String, dynamic> json) => TransaksiModel(
        id: json['id'] ?? 0,
        kodeTransaksi: json['kode_transaksi'] ?? '',
        status: json['status'] ?? '',
        totalHarga: _toDouble(json['total_harga']),
        snapToken: json['snap_token'] ?? '',
        alamatPengiriman: json['alamat_pengiriman'] ?? '',
        noTelepon: json['no_telepon'] ?? '',
        catatan: json['catatan'] ?? '',
        tanggalBayar: json['tanggal_bayar'],
        createdAt: json['created_at'] ?? '',
        items: (json['items'] as List? ?? [])
            .map((e) => TransaksiItemModel.fromJson(e))
            .toList(),
      );
}

/// ✅ Aman untuk nilai String ("12000.00") maupun num (12000)
double _toDouble(dynamic value) {
  if (value == null) return 0.0;
  if (value is double) return value;
  if (value is int) return value.toDouble();
  if (value is String) return double.tryParse(value) ?? 0.0;
  return 0.0;
}
