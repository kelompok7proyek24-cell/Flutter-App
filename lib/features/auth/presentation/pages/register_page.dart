import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  
  // Kontroler untuk Registrasi Akun
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isPasswordVisible = false;

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
                const SizedBox(height: 40),
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
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // Nanti di sini panggil API Node.js: POST /api/auth/register
                        print("Mendaftar dengan: ${_emailController.text}");
                      }
                    },
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
                
                // Pindah ke Login
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

  // Widget Helper untuk Label
  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(text, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey)),
    );
  }

  // Widget Helper untuk Styling Input
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