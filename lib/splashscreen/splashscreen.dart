import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Navigasi ke halaman utama setelah 5 detik
    Future.delayed(const Duration(seconds: 5), () {
      Navigator.pushReplacementNamed(context, '/login');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, 
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Posisi tengah vertikal
          children: [
            // Menampilkan logo aplikasi
            Image.asset(
              'assets/logo_umkm.png',
              width: 150,
              height: 150,
              fit: BoxFit.contain, // Memastikan gambar proporsional
            ),
            const SizedBox(height: 20), // Spasi antara logo dan loading
            _buildLoadingPlaceholder(), // Widget loading indicator custom
          ],
        ),
      ),
    );
  }

  // Method untuk membangun loading indicator
  Widget _buildLoadingPlaceholder() {
    return Container(
      color: Colors.transparent, // Background transparan mengikuti scaffold
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Circular progress indicator dengan ukuran kecil
          SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 4, // Ketebalan garis
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue.shade700), 
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