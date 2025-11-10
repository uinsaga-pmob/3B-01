import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'auth/login_page.dart';
import 'pages/main_page.dart';
import 'splashscreen/splashscreen.dart';

// Fungsi main adalah titik masuk utama aplikasi Flutter
void main() {
  runApp(const MyApp()); // Menjalankan aplikasi dengan widget MyApp
}

// MyApp adalah widget root yang menjadi dasar seluruh aplikasi
=======

void main() {
  runApp(const MyApp());
}

>>>>>>> 3295455aa4e97f0a900b2301153e33dfc9d4032f
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
<<<<<<< HEAD
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
=======
      title: 'Belajar Flutter Kelas ',
      home: Scaffold(
        appBar: AppBar(
          title: Text("Halaman Utama", style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.deepPurpleAccent,
        ),
        body: Center(child: Text("Mulai Belajar Flutter")),
      ),
    );
  }
}
>>>>>>> 3295455aa4e97f0a900b2301153e33dfc9d4032f
