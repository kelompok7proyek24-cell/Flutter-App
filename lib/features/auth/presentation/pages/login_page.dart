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

  Future<void> _handleLogin() async {
    final emailInput = _emailController.text.trim();
    final passwordInput = _passwordController.text;

    if (emailInput.isEmpty || passwordInput.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Email dan Kata Sandi wajib diisi")),
      );
      return;
    }

    // Mengambil data profil yang terdaftar di database lokal
    final savedUser = await ProfileService.getProfile();

    // Validasi sederhana mencocokkan input dengan data terdaftar
    if (emailInput == savedUser.email) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Selamat Datang Kembali, ${savedUser.name}!")),
        );
        
        // Bersihkan tumpukan navigasi dan arahkan langsung ke HomePage
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
          (route) => false,
        );
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Akun tidak ditemukan. Silakan daftar terlebih dahulu.")),
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