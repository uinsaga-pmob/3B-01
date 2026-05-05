# UMKM Digital Helper
Aplikasi Flutter untuk manajemen bisnis UMKM coffee shop yang membantu mengelola produk, transaksi, dan analisis bisnis secara digital.

## Tentang Aplikasi
UMKM Digital Helper adalah solusi all-in-one untuk pemilik coffee shop dalam mengelola operasional bisnis sehari-hari. Aplikasi ini menyediakan dashboard lengkap untuk monitoring penjualan, manajemen produk, dan analisis statistik bisnis.

### Framework & Language
- Flutter 3.9.2 - UI Toolkit cross-platform
- Dart 3.9.2 - Bahasa pemrograman

### Packages & Dependencies
- cached_network_image - Optimasi loading gambar
- connectivity_plus - Deteksi koneksi internet
- lucide_icons - Icon set modern
- intl - Formatting currency dan dates
- cupertino_icons - iOS-style icons

## Struktur Project
```
UMKM_Digital_Helper/
├── lib/
│   ├── main.dart
│
│   ├── core/                         # Konfigurasi global
│   │   ├── constants/
│   │   ├── theme/
│   │   └── utils/
│
│   ├── models/                       # Data model (entitas)
│   │   ├── user_model.dart
│   │   ├── produk_model.dart
│   │   └── transaksi_model.dart
│
│   ├── database/                     # SQLite setup & helper
│   │   └── database_helper.dart
│
│   ├── repositories/                 # Data access layer (CRUD)
│   │   ├── user_repository.dart
│   │   ├── produk_repository.dart
│   │   └── transaksi_repository.dart
│
│   ├── providers/                    # State management
│   │   ├── user_provider.dart
│   │   ├── produk_provider.dart
│   │   └── transaksi_provider.dart
│
│   ├── screens/                      # Semua UI (halaman)
│   │   ├── splash/
│   │   │   └── splash_screen.dart
│   │   │
│   │   ├── auth/
│   │   │   ├── login_screen.dart
│   │   │   └── register_screen.dart
│   │   │
│   │   ├── main/
│   │   │   └── main_screen.dart
│   │   │
│   │   ├── dashboard/
│   │   │   ├── dashboard_screen.dart
│   │   │   └── list_transaksi_screen.dart
│   │   │
│   │   ├── produk/
│   │   │   ├── produk_screen.dart
│   │   │   ├── tambah_produk_screen.dart
│   │   │   └── edit_produk_screen.dart
│   │   │
│   │   ├── transaksi/
│   │   │   ├── tambah_transaksi_screen.dart
│   │   │   └── detail_transaksi_screen.dart
│   │   │
│   │   ├── statistik/
│   │   │   └── statistik_screen.dart
│   │   │
│   │   └── settings/
│   │       ├── settings_screen.dart
│   │       └── akun_screen.dart      # Ambil data dari user_provider
│
│   ├── widgets/                      # Komponen reusable UI
│   │   ├── custom_button.dart
│   │   ├── custom_textfield.dart
│   │   └── card_produk.dart
│
├── assets/
│   ├── images/
│   │   ├── logo_umkm.png
│   │   ├── logo_apk.png
│   │   └── produk/
│   │       ├── kopi_susu_gula_aren.jpg
│   │       ├── kopi_americano.jpg
│   │       └── matcha_latte.jpg
│
├── pubspec.yaml
```