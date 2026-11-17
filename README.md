# Flutter - UMKM Lokal

Aplikasi Flutter yang membaca dan mengubah data melalui REST API CI4. JSON dipetakan ke model `Umkm` dengan `fromJson` dan `toJson`; request memakai package `http` dan `async/await`.

## Menjalankan

1. Jalankan backend di port 8080.
2. Di `flutter-app`, jalankan `flutter pub get`.
3. Android Emulator: `flutter run` memakai `http://10.0.2.2:8080/api`.
4. Flutter Web di komputer yang sama: `flutter run -d chrome --dart-define=API_BASE_URL=http://localhost:8080/api`.

Jika API berada di host lain, set `API_BASE_URL` ke URL server tersebut. Pastikan perangkat dan server berada pada jaringan yang dapat saling dijangkau. Endpoint HTTP tanpa TLS hanya untuk development lokal.

## Fitur

- Memuat daftar UMKM dengan indikator loading, refresh, state kosong, dan pesan error.
- Membuat dan memperbarui data melalui form validasi.
- Menghapus data dengan dialog konfirmasi.
- Menampilkan pesan respons API, termasuk error validasi.
