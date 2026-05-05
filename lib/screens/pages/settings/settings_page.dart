import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'akun_page.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFD),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            const SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    _buildSectionCard(
                      title: 'Akun',
                      icon: LucideIcons.user,
                      children: [
                        _buildSettingItem(
                          icon: LucideIcons.user,
                          title: 'Profil Saya',
                          subtitle: 'Kelola informasi profil Anda',
                          onTap: () => _navigateToAkunPage(context),
                        ),
                        _buildSettingItem(
                          icon: LucideIcons.shield,
                          title: 'Keamanan',
                          subtitle: 'Password dan keamanan akun',
                          onTap: () {},
                        ),
                        _buildSettingItem(
                          icon: LucideIcons.bell,
                          title: 'Notifikasi',
                          subtitle: 'Pengaturan notifikasi aplikasi',
                          onTap: () {},
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildSectionCard(
                      title: 'Bisnis',
                      icon: LucideIcons.building,
                      children: [
                        _buildSettingItem(
                          icon: LucideIcons.store,
                          title: 'Informasi Toko',
                          subtitle: 'Data dan profil bisnis Anda',
                          onTap: () {},
                        ),
                        _buildSettingItem(
                          icon: LucideIcons.barChart3,
                          title: 'Laporan Bisnis',
                          subtitle: 'Analisis dan laporan penjualan',
                          onTap: () {},
                        ),
                        _buildSettingItem(
                          icon: LucideIcons.users,
                          title: 'Manajemen Staff',
                          subtitle: 'Kelola akses staff dan karyawan',
                          onTap: () {},
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildSectionCard(
                      title: 'Aplikasi',
                      icon: LucideIcons.settings,
                      children: [
                        _buildSettingItem(
                          icon: LucideIcons.palette,
                          title: 'Tampilan',
                          subtitle: 'Tema dan preferensi tampilan',
                          onTap: () {},
                        ),
                        _buildSettingItem(
                          icon: LucideIcons.languages,
                          title: 'Bahasa',
                          subtitle: 'Pilih bahasa aplikasi',
                          onTap: () {},
                        ),
                        _buildSettingItem(
                          icon: LucideIcons.database,
                          title: 'Penyimpanan',
                          subtitle: 'Kelola cache dan data aplikasi',
                          onTap: () {},
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildSectionCard(
                      title: 'Bantuan & Dukungan',
                      icon: LucideIcons.helpCircle,
                      children: [
                        _buildSettingItem(
                          icon: LucideIcons.helpCircle,
                          title: 'Pusat Bantuan',
                          subtitle: 'Panduan penggunaan aplikasi',
                          onTap: () {},
                        ),
                        _buildSettingItem(
                          icon: LucideIcons.mail,
                          title: 'Hubungi Kami',
                          subtitle: 'Kontak support dan feedback',
                          onTap: () {},
                        ),
                        _buildSettingItem(
                          icon: LucideIcons.fileText,
                          title: 'Syarat & Ketentuan',
                          subtitle: 'Kebijakan privasi dan ketentuan',
                          onTap: () {},
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade800, Colors.blue.shade600],
        ),
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.shade800.withAlpha(76),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(right: -10, top: -10, child: Container(width: 70, height: 70, decoration: BoxDecoration(color: Colors.white.withAlpha(51), shape: BoxShape.circle))),
          Positioned(right: 25, bottom: -15, child: Container(width: 50, height: 50, decoration: BoxDecoration(color: Colors.white.withAlpha(38), shape: BoxShape.circle))),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 25, 16, 16),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  margin: const EdgeInsets.only(right: 12),
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(64),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white.withAlpha(128), width: 1.5),
                  ),
                  child: const Icon(
                    LucideIcons.settings,
                    color: Colors.white,
                    size: 22,
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Pengaturan",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        "Kelola preferensi aplikasi",
                        style: TextStyle(
                          color: Colors.white.withAlpha(200),
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          height: 1.2,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

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
          ...children,
        ],
      ),
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Column(
      children: [
        Divider(
          height: 1,
          color: Colors.grey.shade200,
        ),
        ListTile(
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: Colors.grey.shade700,
              size: 18,
            ),
          ),
          title: Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
          subtitle: Text(
            subtitle,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
            ),
          ),
          trailing: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(
              LucideIcons.chevronRight,
              size: 16,
              color: Colors.grey.shade600,
            ),
          ),
          onTap: onTap,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
      ],
    );
  }

  void _navigateToAkunPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AkunPage()),
    );
  }
}