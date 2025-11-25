# UMKM Digital Helper
Aplikasi Flutter untuk manajemen bisnis UMKM coffee shop yang membantu mengelola produk, transaksi, dan analisis bisnis secara digital.

## Tentang Aplikasi
UMKM Digital Helper adalah solusi all-in-one untuk pemilik coffee shop dalam mengelola operasional bisnis sehari-hari. Aplikasi ini menyediakan dashboard lengkap untuk monitoring penjualan, manajemen produk, dan analisis statistik bisnis.

### Dashboard
- Ringkasan Keuangan: Total pendapatan, pengeluaran, dan profit
- Statistik Real-time: Update harian/mingguan/bulanan
- Transaksi Terkini: Riwayat transaksi hari ini dan semua waktu
- Quick Overview: Card-based dashboard untuk insight cepat

### Manajemen Produk
- Katalog Produk: Daftar lengkap menu coffee shop
- Kategori Produk: Kopi, Non-Kopi, Snack, Minuman
- Filter & Pencarian: Cari produk berdasarkan nama dan kategori
- Info Stok & Harga: Kelola inventory dan pricing
- Dual Image Support: Gambar lokal dan dari internet

### Pengaturan & Profil
- Manajemen Profil: Data pemilik dan informasi bisnis
- Pengaturan Aplikasi: Tampilan, notifikasi, keamanan
- Info Bisnis: Alamat, jam operasional, tipe bisnis
- Backup & Storage: Kelola data dan cache aplikasi

### Smart Features
- Offline Support: Tetap bisa akses data tanpa internet
- Cached Images: Optimasi loading gambar dengan caching
- Connectivity Detection: Auto-switch antara online/offline mode

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
│   ├── main.dart                     # Entry point aplikasi
│   │
│   ├── splashscreen/                 # Folder splashscreen
│   │   └── splashscreen.dart         # Halaman splash screen
│   │
│   ├── auth/                         # Folder autentikasi
│   │   ├── login_page.dart           # Halaman login
│   │   └── register_page.dart        # Halaman register
│   │
│   ├── pages/                        # Folder utama berisi semua halaman
│   │   ├── main_page.dart            # Wrapper navigasi utama (BottomNav / Drawer)
│   │   │
│   │   ├── dashboard/                # Modul dashboard
│   │   │   ├── dashboard_page.dart   # Halaman utama dashboard
│   │   │   └── list_transaksion.dart # Daftar transaksi (list)
│   │   │
│   │   ├── produk/                   # Modul manajemen produk
│   │   │   ├── produk_page.dart      # Halaman produk utama
│   │   │   └── list_produk.dart      # Daftar produk
│   │   │
│   │   ├── settings/                 # Modul pengaturan
│   │   │   ├── settings_page.dart    # Halaman pengaturan aplikasi
│   │   │   └── akun_page.dart        # Halaman profil pengguna / akun
│   │   │
│   │   └── statistik/                # Modul statistik dan laporan
│   │       └──  statistik_page.dart   # Halaman utama statistik
│   
│ 
├── assets/
│   ├── logo_umkm.png                 # Logo UMKM (untuk header)
│   ├── logo_apk.png                  # Logo utama aplikasi
│   └── produk/                       # Gambar-gambar produk
│       ├── kopi_susu_gula_aren.jpg
│       ├── kopi_americano.jpg
│       └── matcha_latte.jpg
│
└── pubspec.yaml                      # Dependencies dan konfigurasi Flutter
