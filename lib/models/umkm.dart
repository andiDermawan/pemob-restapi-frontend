class Umkm {
  const Umkm({
    required this.id,
    required this.namaUmkm,
    required this.pemilik,
    required this.alamat,
    required this.kategori,
    required this.kontak,
  });

  final int id;
  final String namaUmkm;
  final String pemilik;
  final String alamat;
  final String kategori;
  final String kontak;

  factory Umkm.fromJson(Map<String, dynamic> json) {
    return Umkm(
      id: (json['id'] as num).toInt(),
      namaUmkm: json['nama_umkm'] as String,
      pemilik: json['pemilik'] as String,
      alamat: json['alamat'] as String,
      kategori: json['kategori'] as String,
      kontak: json['kontak'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
    'nama_umkm': namaUmkm,
    'pemilik': pemilik,
    'alamat': alamat,
    'kategori': kategori,
    'kontak': kontak,
  };
}
