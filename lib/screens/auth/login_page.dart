import 'package:flutter/material.dart';
import 'register_page.dart';

// Halaman Login dengan validasi input
// Menggunakan StatefulWidget karena memerlukan state management untuk form
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Controller untuk menangkap input dari TextField
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // Key untuk form validation
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Flag untuk menampilkan/ menyembunyikan password
  bool _obscurePassword = true;

  // Flag untuk loading state
  bool _isLoading = false;

  // Method untuk menampilkan snackbar dengan pesan tertentu
  void _showSnackBar(String message, {bool isSuccess = true}) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
        backgroundColor: isSuccess ? Colors.green : Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  // Method untuk validasi login
  Future<void> _handleLogin() async {
    // Validasi form terlebih dahulu
    if (_formKey.currentState!.validate()) {
      if (!mounted) return;

      setState(() {
        _isLoading = true;
      });

      try {
        // Simulasi proses login
        await Future.delayed(const Duration(milliseconds: 800));

        if (!mounted) return;

        // Tampilkan snackbar sukses
        _showSnackBar('Login berhasil! Selamat datang kembali.');

        // Navigasi ke main page
        Navigator.pushReplacementNamed(context, '/main');
      } catch (e) {
        if (!mounted) return;
        // Tampilkan snackbar error jika login gagal
        _showSnackBar(
          'Terjadi kesalahan. Silakan coba lagi.',
          isSuccess: false,
        );
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  // Method untuk toggle visibility password
  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Form(
          key: _formKey, // Key untuk form validation
          child: Column(
            children: [
              const SizedBox(height: 80),

              // Logo aplikasi
              Center(
                child: Image.asset(
                  'assets/logo_umkm.png',
                  height: 180,
                  fit: BoxFit.contain,
                ),
              ),

              const SizedBox(height: 20),

              // Form input section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    const Text(
                      "Masuk Ke Akun Anda",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),

                    const SizedBox(height: 25),

                    // Email/Phone input field
                    const Text(
                      "Email atau Nomor HP",
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: emailController,
                      decoration: InputDecoration(
                        hintText: 'contoh@email.com atau 081234567890',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: Color(0xFF0A4DA2),
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 12,
                        ),
                        prefixIcon: const Icon(Icons.email_outlined),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Email atau nomor HP harus diisi';
                        }

                        // Validasi format email atau nomor HP
                        final emailRegex = RegExp(
                          r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
                        );
                        final phoneRegex = RegExp(r'^[0-9]{10,13}$');

                        if (!emailRegex.hasMatch(value) &&
                            !phoneRegex.hasMatch(
                              value.replaceAll(RegExp(r'\s+'), ''),
                            )) {
                          return 'Format email atau nomor HP tidak valid';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 10),

                    // Password input field
                    const Text(
                      "Password",
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: passwordController,
                      obscureText: _obscurePassword,
                      decoration: InputDecoration(
                        hintText: 'Masukkan password',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: Color(0xFF0A4DA2),
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 12,
                        ),
                        prefixIcon: const Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: Colors.grey,
                          ),
                          onPressed: _togglePasswordVisibility,
                        ),
                      ),
                      textInputAction: TextInputAction.done,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Password harus diisi';
                        }
                        if (value.length < 6) {
                          return 'Password minimal 6 karakter';
                        }
                        return null;
                      },
                      onFieldSubmitted: (_) => _handleLogin(),
                    ),

                    // Forgot password link
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          _showSnackBar(
                            'Fitur lupa password akan segera hadir!',
                            isSuccess: false,
                          );
                        },
                        child: const Text(
                          'Lupa Password?',
                          style: TextStyle(
                            color: Color(0xFF004AAD),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Tombol login
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _handleLogin,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0A4DA2),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 2,
                          shadowColor: const Color.fromARGB(255, 10, 77, 162),
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                              )
                            : const Text(
                                "Masuk",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Register link
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Belum punya akun? ",
                          style: TextStyle(color: Colors.black54),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const RegisterPage(),
                              ),
                            );
                          },
                          child: const Text(
                            "Daftar Disini",
                            style: TextStyle(
                              color: Color(0xFF004AAD),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
              _buildFooter(),
            ],
          ),
        ),
      ),
    );
  }

  // Footer dengan social login options
  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Text(
            "Atau login dengan",
            style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
          ),
          const SizedBox(height: 16),

          // Social login buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Facebook Button
              InkWell(
                onTap: () {
                  _showSnackBar(
                    'Login dengan Facebook akan segera hadir!',
                    isSuccess: false,
                  );
                },
                borderRadius: BorderRadius.circular(25),
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1877F2),
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF1877F2).withAlpha(76),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.facebook,
                    color: Colors.white,
                    size: 26,
                  ),
                ),
              ),

              const SizedBox(width: 16),

              // Google Button
              InkWell(
                onTap: () {
                  _showSnackBar(
                    'Login dengan Google akan segera hadir!',
                    isSuccess: false,
                  );
                },
                borderRadius: BorderRadius.circular(25),
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(25),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                    border: Border.all(color: Colors.grey.shade300, width: 1),
                  ),
                  child: Center(
                    child: Text(
                      'G',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontFamily: 'Roboto',
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 16),

              // Apple Button
              InkWell(
                onTap: () {
                  _showSnackBar(
                    'Login dengan Apple akan segera hadir!',
                    isSuccess: false,
                  );
                },
                borderRadius: BorderRadius.circular(25),
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withAlpha(76),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Icon(Icons.apple, color: Colors.white, size: 26),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          Divider(color: Colors.grey.shade300, height: 1),

          const SizedBox(height: 16),

          Text(
            "Butuh bantuan? Hubungi support@umkmdigital.com",
            style: TextStyle(color: Colors.grey.shade500, fontSize: 11),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    // Clean up controllers untuk menghindari memory leak
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
