import 'package:flutter/material.dart';
import 'package:ikanku/features/profile/data/models/user_model.dart';
import 'package:ikanku/features/profile/data/datasources/profile_service.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isPasswordVisible = false;

  // Fungsi Registrasi dan Penyimpanan Data ke Database Lokal
  Future<void> _handleRegister() async {
    if (_formKey.currentState!.validate()) {
      // Membuat entitas user baru berdasarkan hasil input form
      final newUser = UserModel(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        phone: "", // Kosongkan awal, nanti diisi di Edit Profile
        address: "", // Kosongkan awal, nanti diisi di Edit Profile
        profileImagePath: null,
        paymentMethod: "", // Kosongkan awal, nanti diisi di Edit Profile
      );

      // Tulis data ke penyimpanan lokal (SharedPreferences)
      await ProfileService.saveProfile(newUser);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Pendaftaran Berhasil! Silakan Masuk.")),
        );
        // Kembali ke Halaman Login setelah berhasil mendaftar
        Navigator.pop(context);
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                const Text(
                  "Buat Akun Baru",
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.blue),
                ),
                const Text(
                  "Silakan daftar untuk mulai menjelajahi Ikanku.id",
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 40),

                // Input Nama Lengkap
                _buildLabel("NAMA LENGKAP"),
                TextFormField(
                  controller: _nameController,
                  validator: (val) => val!.isEmpty ? "Nama tidak boleh kosong" : null,
                  decoration: _inputDecoration("Masukkan nama lengkap", Icons.person_outline),
                ),
                const SizedBox(height: 20),

                // Input Email
                _buildLabel("EMAIL"),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: (val) => !val!.contains("@") ? "Email tidak valid" : null,
                  decoration: _inputDecoration("contoh@mail.com", Icons.email_outlined),
                ),
                const SizedBox(height: 20),

                // Input Password
                _buildLabel("KATA SANDI"),
                TextFormField(
                  controller: _passwordController,
                  obscureText: !_isPasswordVisible,
                  validator: (val) => val!.length < 6 ? "Minimal 6 karakter" : null,
                  decoration: _inputDecoration("******", Icons.lock_outline, isPassword: true),
                ),
                const SizedBox(height: 20),

                // Input Konfirmasi Password
                _buildLabel("KONFIRMASI KATA SANDI"),
                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: !_isPasswordVisible,
                  validator: (val) => val != _passwordController.text ? "Password tidak cocok" : null,
                  decoration: _inputDecoration("******", Icons.lock_reset_outlined),
                ),
                const SizedBox(height: 40),

                // Tombol Daftar
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: _handleRegister,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    ),
                    child: const Text(
                      "DAFTAR",
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                ),
                
                const SizedBox(height: 20),
                
                Center(
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Sudah punya akun? Masuk di sini"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(text, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey)),
    );
  }

  InputDecoration _inputDecoration(String hint, IconData icon, {bool isPassword = false}) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(icon, color: Colors.blue),
      suffixIcon: isPassword 
        ? IconButton(
            icon: Icon(_isPasswordVisible ? Icons.visibility : Icons.visibility_off),
            onPressed: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
          ) 
        : null,
      filled: true,
      fillColor: Colors.grey[100],
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
    );
  }
}