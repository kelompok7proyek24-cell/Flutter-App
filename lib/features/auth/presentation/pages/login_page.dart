import 'package:flutter/material.dart';
import 'package:ikanku/core/constants/colors.dart';
import 'register_page.dart';
// Ganti dengan alamat path home_page.dart proyekmu yang sebenarnya
import 'package:ikanku/features/home/presentation/pages/home_page.dart'; 
import 'package:ikanku/features/profile/data/datasources/profile_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  // =========================================================================
  // LOGIKA UTAMA: AUTENTIKASI AKUN DEMO & VALIDASI STRICT PASSWORD
  // =========================================================================
  Future<void> _handleLogin() async {
    final emailInput = _emailController.text.trim();
    final passwordInput = _passwordController.text;

    // 1. Validasi Awal: Memastikan Input Tidak Kosong
    if (emailInput.isEmpty || passwordInput.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Email dan Kata Sandi wajib diisi")),
      );
      return;
    }

    // 2. Definisi Kredensial Akun Demo Bawaan (Pre-seeded Account)
    const String defaultEmail = "admin@ikanku.com";
    const String defaultPassword = "password123";
    const String defaultName = "Demo User";

    bool isAuthenticated = false;
    String welcomeName = "";

    // Skenario A: Memeriksa apakah menggunakan Akun Demo
    if (emailInput == defaultEmail && passwordInput == defaultPassword) {
      isAuthenticated = true;
      welcomeName = defaultName;
    } 
    // Skenario B: Jika tidak, periksa data yang terdaftar di penyimpanan lokal
    else {
      final savedUser = await ProfileService.getProfile();
      
      // Validasi Ketat: Email DAN Kata Sandi harus sama dengan yang didaftarkan
      if (emailInput == savedUser.email && passwordInput == savedUser.password) {
        isAuthenticated = true;
        welcomeName = savedUser.name;
      }
    }

    // 3. Eksekusi Navigasi Berdasarkan Hasil Autentikasi
    if (isAuthenticated) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Selamat Datang Kembali, $welcomeName!")),
        );
        
        // Bersihkan tumpukan navigasi dan arahkan langsung ke HomePage
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
          (route) => false,
        );
      }
    } else {
      // Jika akun tidak cocok atau kata sandi salah
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Email atau Kata Sandi salah. Periksa kembali data Anda."),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBlue,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Bagian Header Logo
            SizedBox(
              height: 250,
              width: double.infinity,
              child: Center(
                child: Image.network(
                  'https://placeholder_link_to_your_logo_ikanku.png', 
                  width: 200,
                  errorBuilder: (context, error, stackTrace) => const Icon(Icons.cloud_download, size: 50, color: Colors.white),
                ),
              ),
            ),
            
            // Bagian Form Container
            Container(
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Selamat Datang", 
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  const Text("Silahkan lengkapi data anda untuk masuk", 
                    style: TextStyle(color: Colors.grey)),
                  const SizedBox(height: 30),
                  
                  // Email Input
                  const Text("Alamat Email", style: TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      hintText: "nama@example.com",
                      prefixIcon: const Icon(Icons.email_outlined),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                  // Password Input
                  const Text("Kata Sandi", style: TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _passwordController,
                    obscureText: !_isPasswordVisible,
                    decoration: InputDecoration(
                      hintText: "••••••••",
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        icon: Icon(_isPasswordVisible ? Icons.visibility : Icons.visibility_off),
                        onPressed: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
                      ),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                  
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(child: const Text("Lupa Kata Sandi?"), onPressed: () {}),
                  ),
                  const SizedBox(height: 10),
                  
                  // Button Masuk
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryBlue,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      onPressed: _handleLogin,
                      child: const Text("Masuk", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  
                  const SizedBox(height: 20),

                  // Info Box Akun Instan (Mempermudah pengujian dosen/user tanpa registrasi)
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.blue.shade100),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.info_outline, color: Colors.blue.shade700),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Text(
                            "Akun Instan Bawaan:\nEmail: admin@ikanku.com\nSandi: password123",
                            style: TextStyle(fontSize: 12, color: Colors.black87, height: 1.4),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 25),
                  const Center(child: Text("ATAU MASUK DENGAN", style: TextStyle(fontSize: 12, color: Colors.grey))),
                  const SizedBox(height: 15),
                  
                  // Button Registrasi
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                      side: BorderSide(color: Colors.grey.shade300),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const RegisterPage()),
                      );
                    },
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.person_add_alt),
                        SizedBox(width: 10),
                        Text("Buat Akun Baru"),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}