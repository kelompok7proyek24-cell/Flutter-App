import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; //
import 'core/constants/colors.dart'; 
import 'features/home/presentation/pages/home_page.dart';

// Analisis Arcane: Mengubah main menjadi Future agar sistem bisa "menunggu" Firebase
void main() async {
  // 1. Memastikan komunikasi antar-platform (Android/Native) siap
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Inisialisasi Firebase menggunakan konfigurasi google-services.json
  await Firebase.initializeApp();

  runApp(const IkankuApp());
}

class IkankuApp extends StatelessWidget {
  const IkankuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ikanku.id',
      debugShowCheckedModeBanner: false,
      
      theme: ThemeData(
        primaryColor: AppColors.primaryBlue,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: IconThemeData(color: AppColors.primaryBlue),
        ),
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primaryBlue),
      ),

      // Analisis Arcane: Pintu masuk utama sistem adalah LoginPage()
      home: HomePage(), 
    );
  }
}