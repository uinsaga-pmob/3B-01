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
    _initializeApp();
  }
    Future<void> _initializeApp() async {

    await Future.delayed(const Duration(seconds: 5));
    
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, '/login');
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
              'assets/logo_umkm.png',
              width: 150,
              height: 150,
              fit: BoxFit.contain, 
            ),
            const SizedBox(height: 20), 
            _buildLoadingPlaceholder(), 
          ],
        ),
      ),
    );
  }

  // Method untuk membangun loading indicator
  Widget _buildLoadingPlaceholder() {
    return Container(
      color: Colors.transparent, 
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 3, 
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