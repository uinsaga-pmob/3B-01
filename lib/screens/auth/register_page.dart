import 'package:flutter/material.dart';

// Halaman Registrasi dengan validasi lengkap
// Mengimplementasikan form validation untuk semua field required
class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // Controller untuk input field
  final TextEditingController _namaUsahaController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _konfirmasiPasswordController =
      TextEditingController();

  // Key untuk form validation
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Flags untuk password visibility
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  // Flag untuk loading state
  bool _isLoading = false;

  // Method untuk menampilkan snackbar
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

  // Method untuk handle registrasi
  Future<void> _handleRegister() async {
    // Validasi form
    if (_formKey.currentState!.validate()) {
      // Validasi tambahan: password match
      if (_passwordController.text != _konfirmasiPasswordController.text) {
        _showSnackBar(
          'Password dan konfirmasi password tidak cocok',
          isSuccess: false,
        );
        return;
      }

      if (!mounted) return;

      setState(() {
        _isLoading = true;
      });

      try {
        // Simulasi proses registrasi
        await Future.delayed(const Duration(milliseconds: 800));

        if (!mounted) return;

        // Tampilkan snackbar sukses
        _showSnackBar(
          'Pendaftaran berhasil! Akun ${_namaUsahaController.text} telah dibuat.',
        );

        // Navigasi ke main page
        Navigator.pushReplacementNamed(context, '/main');
      } catch (e) {
        if (!mounted) return;

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

  // Toggle password visibility
  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  // Toggle confirm password visibility
  void _toggleConfirmPasswordVisibility() {
    setState(() {
      _obscureConfirmPassword = !_obscureConfirmPassword;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 60),

              // Logo aplikasi
              Center(
                child: Image.asset(
                  'assets/logo_umkm.png',
                  height: 160,
                  fit: BoxFit.contain,
                ),
              ),

              const SizedBox(height: 5),

              // Judul dan subjudul
              const Text(
                'Daftar Akun Baru',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF004AAD),
                ),
              ),
              const SizedBox(height: 5),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 40),
                child: Text(
                  'Mulai Kelola Usaha Anda Dengan Lebih Mudah',
                  style: TextStyle(fontSize: 14, color: Colors.black54),
                  textAlign: TextAlign.center,
                ),
              ),

              const SizedBox(height: 25),

              // Form Input
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Nama Usaha Field
                    const Text(
                      'Nama Usaha',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 5),
                    TextFormField(
                      controller: _namaUsahaController,
                      decoration: _inputDecoration(
                        'Contoh: Kopi Kenangan',
                        icon: Icons.store_outlined,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Nama usaha harus diisi';
                        }
                        if (value.length < 3) {
                          return 'Nama usaha minimal 5 karakter';
                        }
                        return null;
                      },
                      textInputAction: TextInputAction.next,
                    ),

                    const SizedBox(height: 15),

                    // Email/Phone Field
                    const Text(
                      'Email atau Nomor HP',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 5),
                    TextFormField(
                      controller: _emailController,
                      decoration: _inputDecoration(
                        'contoh@gmail.com atau 081234567890',
                        icon: Icons.email_outlined,
                      ),
                      keyboardType: TextInputType.emailAddress,
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
                      textInputAction: TextInputAction.next,
                    ),

                    const SizedBox(height: 15),

                    // Password Field
                    const Text(
                      'Password',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 5),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      decoration: _inputDecoration(
                        'Minimal 6 karakter',
                        icon: Icons.lock_outline,
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
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Password harus diisi';
                        }
                        if (value.length < 6) {
                          return 'Password minimal 6 karakter';
                        }
                        return null;
                      },
                      textInputAction: TextInputAction.next,
                    ),

                    const SizedBox(height: 15),

                    // Konfirmasi Password Field
                    const Text(
                      'Konfirmasi Password',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 5),
                    TextFormField(
                      controller: _konfirmasiPasswordController,
                      obscureText: _obscureConfirmPassword,
                      decoration: _inputDecoration(
                        'Ketik ulang password',
                        icon: Icons.lock_reset_outlined,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureConfirmPassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: Colors.grey,
                          ),
                          onPressed: _toggleConfirmPasswordVisibility,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Konfirmasi password harus diisi';
                        }
                        return null;
                      },
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (_) => _handleRegister(),
                    ),

                    // Password requirements hint
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        '• Password minimal 6 karakter\n• Gunakan kombinasi huruf dan angka',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ),

                    const SizedBox(height: 25),

                    // Tombol daftar
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _handleRegister,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF004AAD),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 2,
                          shadowColor: const Color.fromARGB(255, 0, 74, 173),
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
                                'Daftar Sekarang',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    ),

                    const SizedBox(height: 15),

                    // Terms and conditions
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        'Dengan mendaftar, Anda menyetujui Syarat & Ketentuan serta Kebijakan Privasi kami',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey.shade600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),

                    const SizedBox(height: 15),

                    // Link untuk login
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Sudah punya Akun? ',
                          style: TextStyle(color: Colors.black54),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context); // Kembali ke halaman login
                          },
                          child: const Text(
                            'Masuk di sini',
                            style: TextStyle(
                              color: Color(0xFF004AAD),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  // Fungsi bantu untuk dekorasi input field
  InputDecoration _inputDecoration(
    String hintText, {
    IconData? icon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      hintText: hintText,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.grey),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFF004AAD)),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
      prefixIcon: icon != null ? Icon(icon, color: Colors.grey.shade600) : null,
      suffixIcon: suffixIcon,
    );
  }

  @override
  void dispose() {
    // Clean up semua controller
    _namaUsahaController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _konfirmasiPasswordController.dispose();
    super.dispose();
  }
}
