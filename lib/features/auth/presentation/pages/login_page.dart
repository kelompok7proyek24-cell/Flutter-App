import 'package:flutter/material.dart';
import 'package:ikanku/core/constants/colors.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryBlue,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Bagian Header Logo (Meniru visual desain kamu)
            SizedBox(
              height: 250,
              width: double.infinity,
              child: Center(
                child: Image.network(
                  'https://placeholder_link_to_your_logo_ikanku.png', 
                  width: 200,
                ),
              ),
            ),
            
            // Bagian Form Container
            Container(
              padding: EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Selamat Datang", 
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  Text("Silahkan lengkapi data anda untuk masuk", 
                    style: TextStyle(color: Colors.grey)),
                  SizedBox(height: 30),
                  
                  // Email Input
                  Text("Alamat Email", style: TextStyle(fontWeight: FontWeight.w600)),
                  TextField(
                    decoration: InputDecoration(
                      hintText: "nama@example.com",
                      prefixIcon: Icon(Icons.email_outlined),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                  SizedBox(height: 20),
                  
                  // Password Input
                  Text("Kata Sandi", style: TextStyle(fontWeight: FontWeight.w600)),
                  TextField(
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: "••••••••",
                      prefixIcon: Icon(Icons.lock_outline),
                      suffixIcon: Icon(Icons.visibility_off),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                  
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(child: Text("Lupa Kata Sandi?"), onPressed: () {}),
                  ),
                  
                  // Button Masuk
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryBlue,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      onPressed: () {},
                      child: Text("Masuk", style: TextStyle(color: Colors.white)),
                    ),
                  ),
                  
                  SizedBox(height: 20),
                  Center(child: Text("ATAU MASUK DENGAN")),
                  SizedBox(height: 10),
                  
                  // Button Registrasi
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      minimumSize: Size(double.infinity, 50),
                      side: BorderSide(color: Colors.grey.shade300),
                    ),
                    onPressed: () {},
                    child: Row(
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