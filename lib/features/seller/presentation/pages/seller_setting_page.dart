// Path: lib/features/seller/presentation/pages/seller_setting_page.dart

import 'package:flutter/material.dart';
import 'seller_edit_profile_page.dart';

class SellerSettingPage extends StatelessWidget {
  const SellerSettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Memeriksa apakah halaman dipanggil sebagai halaman mandiri (push) atau di dalam Tab
    final modalRoute = ModalRoute.of(context);
    final isPageNested = modalRoute?.canPop ?? false;

    return Scaffold(
      backgroundColor: const Color(0xffF7F9FC),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        // Sembunyikan tombol back jika dirender di dalam BottomNavigationBar utama
        automaticallyImplyLeading: isPageNested,
        title: const Text(
          "Pengaturan Toko",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 12),
        children: [
          _buildSettingTile(
            icon: Icons.storefront_outlined,
            title: "Manajemen Produk",
            onTap: () {
              // Action manajemen produk
            },
          ),
          _buildSettingTile(
            icon: Icons.notifications_none_outlined,
            title: "Notifikasi Pesanan Masuk",
            onTap: () {
              // Action notifikasi
            },
          ),
          _buildSettingTile(
            icon: Icons.person_outline,
            title: "Edit Profil Akun Seller",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SellerEditProfilePage(),
                ),
              );
            },
          ),
          _buildSettingTile(
            icon: Icons.dark_mode_outlined,
            title: "Tampilan",
            onTap: () {
              // Logika Tema
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSettingTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.08),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: Colors.blue, size: 22),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
        ),
        trailing: const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
        onTap: onTap,
      ),
    );
  }
}