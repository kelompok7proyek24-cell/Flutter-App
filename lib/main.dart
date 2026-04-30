import 'package:flutter/material.dart';
import 'core/constants/colors.dart';
import 'package:firebase_core/firebase_core.dart';
// Sesuaikan import di bawah dengan path folder kamu
import 'package:ikanku/features/auth/data/presentation/pages/login_page.dart'; 
import 'package:ikanku/features/home/presentation/pages/home_page.dart';

void main() {
  runApp(const IkankuApp());
}

class IkankuApp extends StatelessWidget {
  const IkankuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ikanku.id',
      debugShowCheckedModeBanner: false,
      
      // Mengatur Tema Global (Fitur Dasar Sistem)
      theme: ThemeData(
        primaryColor: AppColors.primaryBlue,
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'Sans-Serif', // Pastikan font sudah terdaftar jika ada
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: IconThemeData(color: AppColors.primaryBlue),
        ),
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primaryBlue),
      ),

      // Menentukan halaman awal aplikasi
      // Analisis Arcane: Gunakan LoginPage() untuk alur autentikasi 
      // atau HomePage() jika ingin langsung melihat beranda.
      home: LoginPage(), 
    );
  }
}