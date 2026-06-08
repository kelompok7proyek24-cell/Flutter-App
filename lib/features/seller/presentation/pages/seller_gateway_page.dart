// Path: lib/features/seller/presentation/pages/seller_gateway_page.dart

import 'package:flutter/material.dart';
import 'package:ikanku/features/profile/data/datasources/profile_service.dart';
import 'package:ikanku/features/seller/presentation/pages/seller_dashboard_page.dart'; 
import 'package:ikanku/features/seller/presentation/pages/seller_edit_profile_page.dart'; 

class SellerGatewayPage extends StatefulWidget {
  const SellerGatewayPage({super.key});

  @override
  State<SellerGatewayPage> createState() => _SellerGatewayPageState();
}

class _SellerGatewayPageState extends State<SellerGatewayPage> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    // Jalankan pengecekan setelah frame pertama dirender agar aman melakukan navigasi
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _routingSistemSeller();
    });
  }

  Future<void> _routingSistemSeller() async {
    final user = await ProfileService.getProfile();
    if (!mounted) return;

    if (user.isSeller) {
      // Jika sudah jadi seller, langsung lempar ke Dashboard dan hapus gateway dari stack
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const SellerDashboardPage()),
      );
    } else {
      // JIKA BELUM JADI SELLER: Buka halaman edit/registrasi profil
      // Kita tunggu (await) sampai user menekan tombol 'Simpan' yang mengembalikan data Map
      final Map<String, dynamic>? hasilInputProfil = await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const SellerEditProfilePage()),
      );

      if (!mounted) return;

      // Evaluasi hasil kembalian data
      if (hasilInputProfil != null) {
        // Skenario A: User mengisi data dan menekan tombol SIMPAN
        // Di sini data siap diolah ke langkah berikutnya (Misal: simpan ke local storage/database)
        print("SISTEM: Data toko baru berhasil diterima!");
        print("Nama Toko: ${hasilInputProfil['store_name']}");
        print("Kategori Utama: ${hasilInputProfil['main_category']}");

        // Setelah data diproses, alihkan langsung ke Dashboard Seller
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const SellerDashboardPage()),
        );
      } else {
        // Skenario B: User menekan tombol BACK (membatalkan pendaftaran)
        // Kembalikan user ke halaman SettingsPage asal
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Tampilan Loading Screen Transisi yang bersih saat memeriksa status
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: Colors.blue),
            SizedBox(height: 16),
            Text(
              "Memvalidasi Status Toko...",
              style: TextStyle(
                color: Colors.grey, 
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            )
          ],
        ),
      ),
    );
  }
}