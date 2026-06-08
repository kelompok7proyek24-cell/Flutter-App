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
  @override
  void initState() {
    super.initState();
    // Jalankan pengecekan setelah frame pertama dirender agar aman melakukan navigasi
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _routingSistemSeller();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Simple placeholder while routing logic runs in initState
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Future<void> _routingSistemSeller() async {
    // 1. Ambil data user saat ini dari Profile Service
    final user = await ProfileService.getProfile();
    if (!mounted) return;

    // KONDISI B: Jika sudah terdaftar sebagai seller, langsung bypass ke Dashboard
    if (user.isSeller) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const SellerDashboardPage()),
      );
    } else {
      // KONDISI A: JIKA BELUM JADI SELLER, arahkan untuk membuat akun toko terlebih dahulu
      final Map<String, dynamic>? hasilInputProfil = await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const SellerEditProfilePage()),
      );

      if (!mounted) return;

      // Evaluasi hasil kembalian setelah menekan tombol 'Simpan' di SellerEditProfilePage
      if (hasilInputProfil != null) {
        
        // OPTIMASI UX: Tampilkan loading bar singkat agar user tahu data sedang diproses
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Sedang membuat akun toko..."),
            duration: Duration(milliseconds: 800),
          ),
        );

        try {
          // Eksekusi penyimpanan ke lokal database / SharedPreferences via ProfileService
          // Catatan: Pastikan key map sesuai dengan data yang di-pop dari SellerEditProfilePage
          await ProfileService.becomeSeller(
            storeName: hasilInputProfil['store_name'] ?? 'Aquatic Premium Jakarta',
            category: hasilInputProfil['main_category'] ?? 'Ikan Hias',
          );
        } catch (e) {
          debugPrint("Gagal mengupdate status database seller: $e");
        }

        if (!mounted) return;

        // Setelah data berhasil dibuat, pindahkan stack navigasi langsung ke Dashboard Seller
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const SellerDashboardPage()),
        );
      } else {
        // Skenario jika user membatalkan pendaftaran (menekan tombol back)
        // Kembalikan user ke halaman SettingsPage asal
        Navigator.pop(context);
      }
    }
  }
}