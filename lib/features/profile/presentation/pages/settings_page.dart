// lib/features/profile/presentation/pages/settings_page.dart

import 'package:flutter/material.dart';
import 'edit_profile_page.dart';
// Mengalihkan import ke gateway page agar pengecekan status toko berjalan otomatis
import 'package:ikanku/features/seller/presentation/pages/seller_gateway_page.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F7FA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        title: const Text("Pengaturan", style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            // KONEKSI KE SELLER CENTER VIA GATEWAY
            _settingItem(
              Icons.storefront, 
              "Seller Center", 
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SellerGatewayPage()),
                );
              },
            ),
            
            _settingItem(
              Icons.notifications_none, 
              "Notifikasi",
              onTap: () {
                // Tambahkan aksi jika perlu
              },
            ),
            
            _settingItem(
              Icons.person_outline, 
              "Akun",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const EditProfilePage()),
                );
              },
            ),
            
            _settingItem(
              Icons.palette_outlined, 
              "Tampilan",
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget _settingItem(IconData icon, String title, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap, 
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 18,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.blue),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}