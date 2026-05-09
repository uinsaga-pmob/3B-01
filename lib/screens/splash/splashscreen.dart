import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../providers/auth_provider.dart';
import '../../database/database_helper.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {

    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    // Ambil auth provider
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    
    // Cek apakah sudah ada user di database
    final hasUser = await _hasUserInDatabase();
    
    if (!mounted) return;

    if (!hasUser) {
      // Jika belum ada user → Arahkan ke halaman register
      debugPrint('No user found, redirecting to REGISTER screen');
      Navigator.pushReplacementNamed(context, '/register');
    } else {
      // Jika sudah ada user → Cek session login
      final isLoggedIn = await _checkSession(authProvider);
      
      if (!mounted) return;

      if (isLoggedIn) {
        // jika sudah login → Langsung ke main_page
        debugPrint('User logged in, redirecting to MAIN page');
        Navigator.pushReplacementNamed(context, '/main');
      } else {
        // Belum login → Arahkan ke halaman login 
        debugPrint('User exists but not logged in, redirecting to LOGIN screen');
        Navigator.pushReplacementNamed(context, '/login');
      }
    }
  }

  /// Mengecek apakah sudah ada user di database
  Future<bool> _hasUserInDatabase() async {
    try {
      final dbHelper = DatabaseHelper();
      final hasUser = await dbHelper.hasUser();
      debugPrint('Database has user: $hasUser');
      return hasUser;
    } catch (e) {
      debugPrint('Error checking user in database: $e');
      return false;
    }
  }

  /// Mengecek session dari SharedPreferences
  Future<bool> _checkSession(AuthProvider authProvider) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final isLoggedIn = prefs.getBool('is_logged_in') ?? false;
      
      if (isLoggedIn) {
        final userId = prefs.getInt('user_id');
        if (userId != null) {
          final user = await authProvider.loadUserFromId(userId);
          if (user != null) {
            debugPrint('Session valid for user: ${user.username}');
            return true;
          }
        }
      }
      
      debugPrint('No valid session found');
      return false;
    } catch (e) {
      debugPrint('Error checking session: $e');
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/logo_umkm.png',
              width: 180,
              height: 180,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 180,
                  height: 180,
                  decoration: BoxDecoration(
                    color: const Color(0xFF004AAD).withAlpha(25),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.store,
                    size: 100,
                    color: Color(0xFF004AAD),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),

            const Text(
              'UMKM Digital Helper',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF004AAD),
                letterSpacing: 1,
              ),
            ),
            
            const SizedBox(height: 8),
            
            Text(
              'Kelola Usaha Lebih Mudah',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
            
            const SizedBox(height: 40),
            
            _buildLoadingPlaceholder(),
            
            const SizedBox(height: 40),
            
            Text(
              'Version 1.0.0',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingPlaceholder() {
    return Column(
      children: [
        SizedBox(
          width: 35,
          height: 35,
          child: CircularProgressIndicator(
            strokeWidth: 3,
            valueColor: const AlwaysStoppedAnimation<Color>(
              Color(0xFF004AAD),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Memuat aplikasi...',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade600,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}