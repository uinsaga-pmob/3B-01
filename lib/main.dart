import 'package:flutter/material.dart';
import 'auth/login_page.dart';
import 'pages/main_page.dart';
import 'splashscreen/splashscreen.dart';

// Fungsi main adalah titik masuk utama aplikasi Flutter
void main() {
  runApp(const MyApp()); // Menjalankan aplikasi dengan widget MyApp
}

// MyApp adalah widget root yang menjadi dasar seluruh aplikasi
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Menyembunyikan banner debug
      title: 'UMKM Digital Helper', // Judul aplikasi
      initialRoute: '/splash', // Route pertama yang dijalankan saat app start
      routes: {
        // Mendefinisikan routing aplikasi
        '/splash': (context) => const SplashScreen(), // Splashscreen/loading
        '/login': (context) => const LoginPage(), // Halaman login
        '/main': (context) => const MainPage(), // Navigasi ke beberapa halaman 
      },
    );
  }
}