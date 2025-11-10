import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class AkunPage extends StatelessWidget {
  const AkunPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFD), // Background color light blue/grey
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(LucideIcons.arrowLeft, color: Colors.black87),
          onPressed: () => Navigator.pop(context), // Navigation back action
        ),
        title: const Text(
          'Profil Saya',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Profile Header Card dengan foto dan info dasar
              _buildProfileHeader(),
              const SizedBox(height: 20),

              // Account Information Section
              _buildSectionCard(
                title: 'Informasi Akun',
                icon: LucideIcons.user,
                children: [
                  _buildInfoItem(
                    icon: LucideIcons.user,
                    title: 'Nama Lengkap',
                    value: 'Syahroni',
                    onTap: () {}, 
                  ),
                  _buildInfoItem(
                    icon: LucideIcons.building,
                    title: 'Nama Bisnis',
                    value: "Syahroni's Coffee Shop",
                    onTap: () {}, 
                  ),
                  _buildInfoItem(
                    icon: LucideIcons.mail,
                    title: 'Email',
                    value: 'syahroni@coffee.com',
                    onTap: () {}, 
                  ),
                  _buildInfoItem(
                    icon: LucideIcons.phone,
                    title: 'Nomor Telepon',
                    value: '+62 812-3456-7890',
                    onTap: () {}, 
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Business Information Section
              _buildSectionCard(
                title: 'Informasi Bisnis',
                icon: LucideIcons.store,
                children: [
                  _buildInfoItem(
                    icon: LucideIcons.mapPin,
                    title: 'Alamat',
                    value: 'Jl. Coffee Street No. 123, Jakarta',
                    onTap: () {}, 
                  ),
                  _buildInfoItem(
                    icon: LucideIcons.clock,
                    title: 'Jam Operasional',
                    value: '07:00 - 22:00 WIB',
                    onTap: () {}, 
                  ),
                  _buildInfoItem(
                    icon: LucideIcons.fileText,
                    title: 'Tipe Bisnis',
                    value: 'Coffee Shop',
                    onTap: () {}, 
                  ),
                ],
              ),
              const SizedBox(height: 30),

              // Action Buttons (Logout, dll)
              _buildActionButtons(context),
            ],
          ),
        ),
      ),
    );
  }

  /// [FUNGSI UTAMA] - Profile Header dengan foto dan info dasar pengguna
  /// Menampilkan:
  /// - Foto profil dari assets
  /// - Nama pengguna dan nama bisnis
  /// - Status akun (Aktif)
  /// - Tombol edit profil
  Widget _buildProfileHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade100,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Profile Avatar dengan gambar dari assets
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.blue.shade100, // Fallback color jika gambar tidak load
              borderRadius: BorderRadius.circular(40), // Circular avatar
              image: const DecorationImage(
                image: AssetImage('assets/logo_umkm.png'), 
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 16),
          // Profile Information Section
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Syahroni', 
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "Syahroni's Coffee Shop", 
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 8),
                // Status Badge, Menunjukkan akun aktif
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.green.shade100), 
                  ),
                  child: Text(
                    'Aktif', 
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.green.shade700,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Edit Profile Button
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.blue.shade50, 
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              LucideIcons.edit3,
              color: Colors.blue.shade700,
              size: 18,
            ),
          ),
        ],
      ),
    );
  }

  /// Fungsi Reusable card container untuk section informasi
  /// Digunakan untuk mengelompokkan informasi terkait (akun, bisnis, dll)
  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade100,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Header dengan icon dan title
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50, 
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    icon,
                    color: Colors.blue,
                    size: 18,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
          // Section Items - list informasi
          ...children,
        ],
      ),
    );
  }

  /// Item informasi individual yang dapat diklik
  /// Setiap item menampilkan:
  /// - Icon representatif
  /// - Title informasi
  /// - Value/nilai informasi
  /// - Edit icon sebagai indikasi dapat diedit
  Widget _buildInfoItem({
    required IconData icon,
    required String title,
    required String value,
    required VoidCallback onTap,
  }) {
    return Column(
      children: [
        Divider(
          height: 1,
          color: Colors.grey.shade200, // Divider antar item
        ),
        ListTile(
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey.shade50, // Background icon
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: Colors.grey.shade700,
              size: 18,
            ),
          ),
          title: Text(
            title, // Label informasi (contoh: "Email", "Nomor Telepon")
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
          subtitle: Text(
            value, // Nilai informasi (contoh: "syahroni@coffee.com")
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey.shade600,
            ),
          ),
          trailing: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.grey.shade100, // Background edit icon
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(
              LucideIcons.edit3,
              size: 14,
              color: Colors.grey.shade600,
            ),
          ),
          onTap: onTap, // Callback ketika item diklik
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ],
    );
  }

  /// Action buttons di bagian bawah halaman
  /// Saat ini hanya berisi tombol logout
  Widget _buildActionButtons(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 12),
        // Logout Button
        SizedBox(
          width: double.infinity, 
          child: OutlinedButton(
            onPressed: () {
              // - Clear user session
              // - Navigate to login page
              // - Show confirmation dialog
            },
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              side: BorderSide(color: Colors.red.shade300), 
            ),
            child: Text(
              'Keluar', // Logout action text
              style: TextStyle(
                color: Colors.red.shade600, 
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }
}