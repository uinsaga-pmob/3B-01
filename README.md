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
- sqlite - database lokal
- path - manipulasi path file 
- path_provider - mendapatkan direktori aplikasi 
- shared_preferences - local storage / menyimpan data sederhana (key-value)
- provider - mengelola state aplikasi 

## Struktur Project
```
UMKM_Digital_Helper/
├── lib/
│   ├── main.dart
│   │
│   ├── database/
│   │   └── database_helper.dart
│   │
│   ├── models/
│   │   └── user_model.dart
│   │
│   ├── providers/
│   │   └── auth_provider.dart          
│   │
│   ├── repositories/
│   │   └── user_repository.dart
│   │
│   ├── screens/
│   │   ├── splash/
│   │   │   └── splashscreen.dart
│   │   │
│   │   ├── auth/
│   │   │   ├── login_screen.dart
│   │   │   └── register_screen.dart
│   │   │
│   │   └── pages/
│   │       ├── main_page.dart
│   │       │
│   │       ├── dashboard/
│   │       │   ├── dashboard_page.dart
│   │       │   └── list_transaksion.dart
│   │       │
│   │       ├── produk/
│   │       │   ├── produk_page.dart
│   │       │   └── list_produk.dart
│   │       │
│   │       ├── statistik/
│   │       │   ├── statistik_page.dart
│   │       │   └── statistik_data.dart
│   │       │
│   │       └── settings/
│   │           ├── settings_page.dart
│   │           └── akun_page.dart
│   │
│   └── shared/
│       ├── themes/                     
│       └── widgets/
│           └── custom_app_bar.dart
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


## Arsitektur Aplikasi
```
┌─────────────────────────────────────────────────────────────────────────────┐
│                           UI LAYER (View)                                   │
│         ┌──────────────┐ ┌──────────────┐ ┌──────────────────┐              │
│         │ LoginScreen  │ │RegisterScreen│ │  DashboardPage   │              │
│         └──────────────┘ └──────────────┘ └──────────────────┘              │
│                                                                             │                                                                  
│  • Menampilkan form input ke layar (TextField, Button)                      │
│  • Menerima input dari user (username, password, dll)                       │
│  • Menampilkan loading indicator saat proses berlangsung                    │
│  • Melakukan navigasi antar halaman                                         │
│                                                                             │
│  CARA KERJA:                                                                │
│  1. User mengetik username dan password di TextField                        │
│  2. User menekan tombol "Login" atau "Register"                             │
│  3. Screen memanggil Provider.of<AuthProvider>(context)                     │
│  4. Screen memanggil method di provider (login/register)                    │
│  5. Screen merespon perubahan state (loading, error, success)               │
│                                                                             │
│              ↓ Provider.of<AuthProvider>(context)                           │
└─────────────────────────────────────────────────────────────────────────────┘
                                  ↓    
┌─────────────────────────────────────────────────────────────────────────────┐
│                         STATE MANAGEMENT LAYER                              │
│  ┌─────────────────────────────────────────────────────────────────────┐    │
│  │                         AuthProvider                                │    │
│  │                                                                     │    │
│  │  STATE (Data yang disimpan):                                        │    │
│  │  • _currentUser    → UserModel? (data user yang login)              │    │
│  │  • _isLoading      → bool (status loading, true/false)              │    │
│  │  • _errorMessage   → String? (pesan error jika ada)                 │    │
│  │                                                                     │    │
│  │  ACTIONS (Method yang bisa dipanggil UI):                           │    │
│  │  • login(username, password)  → Future<bool>                        │    │
│  │  • register(user)             → Future<bool>                        │    │
│  │  • logout()                   → Future<void>                        │    │
│  │  • loadUserFromId(userId)     → Future<UserModel?>                  │    │
│  │  • checkSession()             → Future<bool>                        │    │
│  │                                                                     │    │
│  │  TUGAS:                                                             │    │
│  │  • Menyimpan state aplikasi (data yang bisa berubah)                │    │
│  │  • Mengubah state (misal: _isLoading = true/false)                  │    │
│  │  • Memberi tahu UI bahwa state berubah (notifyListeners())          │    │
│  │  • Memanggil repository untuk operasi data                          │    │
│  │  • Mengelola session (SharedPreferences)                            │    │
│  │                                                                     │    │
│  │  CARA KERJA:                                                        │    │
│  │  1. UI memanggil authProvider.login("john", "123")                  │    │
│  │  2. Provider mengubah _isLoading = true → notifyListeners()         │    │
│  │  3. UI otomatis menampilkan loading indicator                       │    │
│  │  4. Provider memanggil userRepository.login()                       │    │
│  │  5. Jika berhasil: _currentUser = user → notifyListeners()          │    │
│  │  6. UI otomatis menampilkan data user dan navigasi ke halaman utama │    │
│  │  7. Jika gagal: _errorMessage = "..." → notifyListeners()           │    │
│  │  8. UI otomatis menampilkan pesan error                             │    │
│  │                                                                     │    │
│  └─────────────────────────────────────────────────────────────────────┘    │
│                                                                             │
│              ↓ call methods (await userRepository.login())                  │
└─────────────────────────────────────────────────────────────────────────────┘
                                     ↓
┌─────────────────────────────────────────────────────────────────────────────┐
│                           BUSINESS LOGIC LAYER                              │
│  ┌─────────────────────────────────────────────────────────────────────┐    │
│  │                        UserRepository                               │    │
│  │                                                                     │    │
│  │  TUGAS:                                                             │    │
│  │  • Memvalidasi data sebelum ke database                             │    │
│  │  • Mengecek apakah username sudah digunakan                         │    │
│  │  • Mentransformasi data (Model → Map untuk database)                │    │
│  │  • Mentransformasi data (Map → Model untuk UI)                      │    │
│  │  • Menangani error dan melempar exception                           │    │
│  │  • Menyusun query logic yang kompleks                               │    │
│  │                                                                     │    │
│  │  CARA KERJA:                                                        │    │
│  │  1. Menerima UserModel dari provider                                │    │
│  │  2. Validasi: cek apakah username sudah terdaftar                   │    │
│  │     → getUserByUsername(username)                                   │    │
│  │  3. Jika sudah ada → throw Exception("Username sudah digunakan")    │    │
│  │  4. Jika belum: konversi UserModel ke Map                           │    │
│  │     → user.toMap() → {username: "john", password: "123", ...}       │    │
│  │  5. Hapus key 'id' karena auto increment                            │    │
│  │     → data.remove('id')                                             │    │
│  │  6. Panggil database_helper.insert('user', data)                    │    │
│  │  7. Kembalikan ID user yang baru dibuat ke provider                 │    │
│  │                                                                     │    │
│  │  VALIDASI YANG DILAKUKAN:                                           │    │
│  │  • Username minimal 3 karakter                                      │    │
│  │  • Password minimal 6 karakter                                      │    │
│  │  • Username harus unik (belum ada yang pakai)                       │    │
│  │  • Email format (jika ada)                                          │    │
│  │  • Nomor telepon (jika ada)                                         │    │
│  │                                                                     │    │
│  └─────────────────────────────────────────────────────────────────────┘    │
│                                                                             │
│                ↓ call methods (await dbHelper.insert())                     │
└─────────────────────────────────────────────────────────────────────────────┘
                                     ↓
┌─────────────────────────────────────────────────────────────────────────────┐
│                           DATA ACCESS LAYER                                 │
│  ┌─────────────────────────────────────────────────────────────────────┐    │
│  │                        DatabaseHelper                               │    │
│  │                                                                     │    │
│  │  TUGAS:                                                             │    │
│  │  • Membuka dan menutup koneksi database                             │    │
│  │  • Membuat tabel saat pertama kali aplikasi diinstall               │    │
│  │  • Menyediakan method CRUD dasar:                                   │    │
│  │    - insert(table, data) → Future<int> (return ID)                  │    │
│  │    - update(table, data, id) → Future<int> (rows affected)          │    │
│  │    - delete(table, id) → Future<int> (rows affected)                │    │
│  │    - getAll(table) → Future<List<Map>>                              │    │
│  │    - getById(table, id) → Future<Map?>                              │    │
│  │  • Menyediakan method raw query untuk query kompleks:               │    │
│  │    - rawQuery(sql, args) → Future<List<Map>>                        │    │
│  │    - rawInsert(sql, args) → Future<int>                             │    │
│  │  • Menyediakan method batch untuk operasi massal                    │    │
│  │  • Menambahkan timestamp otomatis (created_at, updated_at)          │    │
│  │                                                                     │    │
│  │  CARA KERJA:                                                        │    │
│  │  1. Menerima parameter: table name dan data dalam bentuk Map        │    │
│  │  2. Tambahkan created_at dan updated_at otomatis                    │    │
│  │     → data['created_at'] = DateTime.now().toIso8601String()         │    │
│  │     → data['updated_at'] = DateTime.now().toIso8601String()         │    │
│  │  3. Eksekusi SQL INSERT/UPDATE/DELETE/SELECT                        │    │
│  │  4. Kembalikan hasil ke repository                                  │    │
│  │                                                                     │    │
│  └─────────────────────────────────────────────────────────────────────┘    │
│                                                                             │
│                         ↓ Eksekusi SQL Query                                │
└─────────────────────────────────────────────────────────────────────────────┘
                                    ↓
┌─────────────────────────────────────────────────────────────────────────────┐
│                             DATABASE LAYER                                  │
│  ┌─────────────────────────────────────────────────────────────────────┐    │
│  │                        SQLite Database                              │    │
│  │                                                                     │    │
│  │  FILE: umkm_digital_helper.db                                       │    │
│  │  LOKASI: getApplicationDocumentsDirectory()                         │    │
│  │                                                                     │    │
│  │  TABEL: user                                                        │    │
│  │  ┌─────┬──────────┬──────────┬──────────────┬─────────────┐         │    │
│  │  │ id  │ username │ password │ nama_bisnis  │ created_at  │         │    │
│  │  ├─────┼──────────┼──────────┼──────────────┼─────────────┤         │    │
│  │  │ 1   │ admin    │ admin123 │   WarungKu   │ 2024-01-01  │         │    │
│  │  └─────┴──────────┴──────────┴──────────────┴─────────────┘         │    │
│  │                                                                     │    │
│  │  TUGAS:                                                             │    │
│  │  • Menyimpan data secara permanen di perangkat user                 │    │
│  │  • Data tetap ada meskipun aplikasi ditutup                         │    │
│  │  • Data hanya hilang jika user uninstall aplikasi                   │    │
│  │                                                                     │    │
│  │  CARA KERJA:                                                        │    │
│  │  1. Menerima perintah SQL dari DatabaseHelper                       │    │
│  │     → INSERT INTO user (username, password, ...) VALUES (?, ...)    │    │
│  │  2. Menyimpan data ke file database                                 │    │
│  │  3. Mengembalikan hasil query ke DatabaseHelper                     │    │
│  │     → SELECT * FROM user WHERE username = 'john'                    │    │
│  │  4. Mengembalikan data dalam bentuk List<Map<String, dynamic>>      │    │
│  │                                                                     │    │
│  └─────────────────────────────────────────────────────────────────────┘    │
└─────────────────────────────────────────────────────────────────────────────┘
```

## Cara kerja Provider
```
┌─────────────────────────────────────────────────────────────────┐
│                         PROVIDER                                │
│  ┌─────────────────────────────────────────────────────────┐    │
│  │  1. STATE (Data)                                        │    │
│  │     - _currentUser                                      │    │
│  │     - _isLoading                                        │    │
│  │     - _errorMessage                                     │    │
│  ├─────────────────────────────────────────────────────────┤    │
│  │  2. NOTIFIER (ChangeNotifier)                           │    │
│  │     - notifyListeners() → memberi tahu UI ada perubahan │    │
│  ├─────────────────────────────────────────────────────────┤    │
│  │  3. ACTIONS (Methods)                                   │    │
│  │     - login() / register() / logout()                   │    │
│  │     - updateState() → setState + notifyListeners()      │    │
│  └─────────────────────────────────────────────────────────┘    │
└─────────────────────────────────────────────────────────────────┘
                              ↓ notifyListeners()
┌─────────────────────────────────────────────────────────────────┐
│                              UI                                 │
│  ┌─────────────────────────────────────────────────────────┐    │
│  │  Provider.of<AuthProvider>(context)                     │    │
│  │     ↓                                                   │    │
│  │  Mendapatkan akses ke state dan actions                 │    │
│  │     ↓                                                   │    │
│  │  UI otomatis re-render ketika state berubah             │    │
│  └─────────────────────────────────────────────────────────┘    │
└─────────────────────────────────────────────────────────────────┘
```