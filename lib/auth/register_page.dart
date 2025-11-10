import 'package:flutter/material.dart';

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
  final TextEditingController _konfirmasiPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [

            const SizedBox(height: 80),

            Center(
              child: Image.asset(
                'assets/logo_umkm.png',
                height: 180,
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
            const Text(
              'Mulai Kelola Usaha Anda Dengan Lebih Mudah',
              style: TextStyle(fontSize: 14, color: Colors.black54),
            ),

            const SizedBox(height: 25),

            // Form Input
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Nama Usaha'),
                  const SizedBox(height: 5),
                  TextField(
                    controller: _namaUsahaController,
                    decoration: _inputDecoration('Nama Usaha'),
                  ),

                  const SizedBox(height: 15),
                  const Text('Email atau Nomor HP'),
                  const SizedBox(height: 5),
                  TextField(
                    controller: _emailController,
                    decoration: _inputDecoration('Email atau Nomor HP'),
                  ),

                  const SizedBox(height: 15),
                  const Text('Password'),
                  const SizedBox(height: 5),
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: _inputDecoration('Password'),
                  ),

                  const SizedBox(height: 15),
                  const Text('Konfirmasi Password'),
                  const SizedBox(height: 5),
                  TextField(
                    controller: _konfirmasiPasswordController,
                    obscureText: true,
                    decoration: _inputDecoration('Konfirmasi Password'),
                  ),

                  const SizedBox(height: 25),

                  // Tombol daftar
                  SizedBox(
                    width: double.infinity,
                    height: 45,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, '/main');
                      },                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF004AAD),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Daftar Sekarang',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),

                  // Teks "Sudah punya akun?"
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Sudah punya Akun? '),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context); // kembali ke halaman login
                        },
                        child: const Text(
                          'Masuk di sini',
                          style: TextStyle(
                            color: Color(0xFF004AAD),
                            fontWeight: FontWeight.bold,
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
    );
  }

  

  // Fungsi bantu dekorasi input
  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
    );
  }
}
