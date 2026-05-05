import 'package:flutter/material.dart';

/// SplashScreen  aplikasi dengan logo dan loading indicator
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initializeApp(); // Memulai proses inisialisasi aplikasi saat widget diinisialisasi
  }

  /// Fungsi untuk menginisialisasi aplikasi dan menavigasi ke halaman login setelah delay
  Future<void> _initializeApp() async {
    await Future.delayed(const Duration(seconds: 5));

    // Mengecek apakah widget masih terpasang sebelum melakukan navigasi
    if (!mounted) return;

    // Navigasi ke halaman login dengan mengganti route saat ini
    // sehingga pengguna tidak bisa kembali ke splash screen dengan tombol back
    Navigator.pushReplacementNamed(context, '/main');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center, // Konten dipusatkan vertikal
          children: [
            Image.asset(
              'assets/logo_umkm.png',
              width: 150,
              height: 150,
              fit: BoxFit
                  .contain, // Memastikan logo sesuai dengan ukuran yang ditentukan
            ),
            const SizedBox(height: 20),
            _buildLoadingPlaceholder(), // Widget loading indicator dengan teks
          ],
        ),
      ),
    );
  }

  /// Method untuk membangun widget loading indicator
  Widget _buildLoadingPlaceholder() {
    return Container(
      color: Colors.transparent, // Container dengan latar transparan
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // CircularProgressIndicator untuk menunjukkan proses loading
          SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 3, // Ketebalan garis loading indicator
              valueColor: AlwaysStoppedAnimation<Color>(
                Colors.blue.shade700, // Warna biru untuk loading indicator
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Loading...',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w300,
            ),
          ),
        ],
      ),
    );
  }
}
