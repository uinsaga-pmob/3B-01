import 'package:flutter/material.dart';
import 'dashboard/dashboard_page.dart';
import 'statistik/statistik_page.dart';
import 'produk/produk_page.dart';
import 'settings/settings_page.dart';

// MainPage sebagai StatefulWidget untuk menangani state navigation
class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0; // Menyimpan index tab yang aktif

  // List widget untuk setiap halaman dalam bottom navigation
  final List<Widget> _pages = const [
    DashboardPage(),      // Halaman dashboard utama
    StatisticsPage(),     // Halaman statistik dan analisis
    ProductsPage(),       // Halaman manajemen produk
    SettingsPage()        // Halaman pengaturan aplikasi
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Menampilkan halaman sesuai dengan index yang dipilih
      body: _pages[_selectedIndex],
      
      // Bottom Navigation Bar untuk navigasi antar halaman
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed, // Tampilan fixed untuk lebih dari 3 item
        currentIndex: _selectedIndex, // Index yang sedang aktif
        onTap: (index) {
          setState(() {
            _selectedIndex = index; // Update state ketika tab diklik
          });
        },
        backgroundColor: Colors.white, // Background color putih
        selectedItemColor: const Color(0xFF0A4DA2), // Warna biru untuk item aktif
        unselectedItemColor: Colors.grey, // Warna abu-abu untuk item non-aktif
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard', // Label untuk halaman dashboard
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Statistik', // Label untuk halaman statistik
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag),
            label: 'Produk', // Label untuk halaman produk
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Pengaturan', // Label untuk halaman pengaturan
          ),
        ],
      ),
    );
  }
}