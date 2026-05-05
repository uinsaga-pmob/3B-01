import 'package:flutter/material.dart';
import 'screens/auth/login_page.dart';
import 'screens/pages/main_page.dart';
import 'screens/splashscreen/splashscreen.dart';
void main() {
  runApp(const MyApp()); 
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, 
      title: 'UMKM Digital Helper', 
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