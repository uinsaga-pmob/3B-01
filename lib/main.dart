import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'database/database_helper.dart';
import 'providers/auth_provider.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/pages/main_page.dart';
import 'screens/splash/splashscreen.dart';

void main() async {
  // Pastikan widget binding terinisialisasi
  WidgetsFlutterBinding.ensureInitialized();
  
  // Inisialisasi database
  await _initDatabase();
  
  runApp(const MyApp());
}

Future<void> _initDatabase() async {
  try {
    final dbHelper = DatabaseHelper();
    await dbHelper.database;
    debugPrint('Database initialized successfully');
  } catch (e) {
    debugPrint('Database initialization failed: $e');
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'UMKM Digital Helper',
        initialRoute: '/splash',
        routes: {
          '/splash': (context) => const SplashScreen(),
          '/register' : (context) => const RegisterScreen(),
          '/login': (context) => const LoginScreen(),
          '/main': (context) => const MainPage(),
        },
      ),
    );
  }
}