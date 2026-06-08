// Path: lib/features/seller/presentation/pages/seller_dashboard_page.dart

import 'package:flutter/material.dart';
import 'seller_setting_page.dart';
import 'seller_edit_profile_page.dart'; // Ditambahkan untuk kebutuhan tab alternatif
import 'package:ikanku/features/seller/data/models/product_model.dart';
import 'package:ikanku/features/seller/widgets/inventory_item_tile.dart';
import 'package:ikanku/features/seller/widgets/revenue_card.dart';
import 'package:ikanku/features/profile/data/models/user_model.dart';
import 'package:ikanku/features/profile/data/datasources/profile_service.dart';

class SellerDashboardPage extends StatefulWidget {
  const SellerDashboardPage({super.key});

  @override
  State<SellerDashboardPage> createState() => _SellerDashboardPageState();
}

class _SellerDashboardPageState extends State<SellerDashboardPage> {
  late Future<UserModel> _sellerDataFuture;
  int _currentIndex = 0; // State untuk melacak tab aktif

  @override
  void initState() {
    super.initState();
    _sellerDataFuture = ProfileService.getProfile();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserModel>(
      future: _sellerDataFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            backgroundColor: Colors.white,
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError || !snapshot.hasData) {
          return const Scaffold(
            body: Center(child: Text("Gagal memuat profil toko")),
          );
        }

        final seller = snapshot.data!;

        // Mengatur daftar tampilan body berdasarkan index footer
        final List<Widget> _pages = [
          _buildMainDashboardBody(seller),
          _buildProductManagementBody(),
          const SellerSettingPage(), // Mengintegrasikan langsung halaman setting sebagai Tab Akun
        ];

        return Scaffold(
          backgroundColor: const Color(0xffF7F9FC),
          appBar: _currentIndex == 0 
              ? AppBar(
                  elevation: 0,
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Navigator.pop(context),
                  ),
                  title: const Text(
                    "Akun Seller",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  actions: [
                    IconButton(icon: const Icon(Icons.notifications_none_outlined), onPressed: () {}),
                    IconButton(
                      icon: const Icon(Icons.settings_outlined),
                      onPressed: () {
                        setState(() {
                          _currentIndex = 2; // Pindah langsung ke Tab Pengaturan/Akun
                        });
                      },
                    ),
                  ],
                )
              : null, // Biar AppBar halaman setting/produk tidak bertabrakan
          body: SafeArea(
            child: _pages[_currentIndex],
          ),
          // IMPLEMENTASI FOOTER NAVIGASI SELLER BARU
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            type: BottomNavigationBarType.fixed,
            selectedItemColor: Colors.blue,
            unselectedItemColor: Colors.grey,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                activeIcon: Icon(Icons.home),
                label: 'Beranda',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.layers_outlined),
                activeIcon: Icon(Icons.layers),
                label: 'Produk',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_outline),
                activeIcon: Icon(Icons.person),
                label: 'Akun',
              ),
            ],
          ),
        );
      },
    );
  }

  // Memisahkan komponen utama dashboard ke widget tersendiri
  Widget _buildMainDashboardBody(UserModel seller) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildProfileCard(seller),
          const SizedBox(height: 20),
          _buildFinancialSection(),
          const SizedBox(height: 20),
          _buildPerformanceChart(),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Inventory (42 items)",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    _currentIndex = 1; // Pindah ke tab manajemen produk
                  });
                },
                child: const Text("View All", style: TextStyle(color: Colors.blue)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          _buildInventoryList(),
        ],
      ),
    );
  }

  Widget _buildProductManagementBody() {
    return const Center(
      child: Text("Halaman Manajemen Produk Seller", style: TextStyle(fontWeight: FontWeight.bold)),
    );
  }

  // WIDGET PEMBANTU UI TETAP (Sama seperti kode Anda)
  Widget _buildProfileCard(UserModel seller) {
    return Row(
      children: [
        Stack(
          children: [
            CircleAvatar(
              radius: 32,
              backgroundColor: Colors.blue.shade900,
              child: const Icon(Icons.store, color: Colors.white, size: 30),
            ),
            const Positioned(
              bottom: 0,
              right: 0,
              child: CircleAvatar(
                radius: 10,
                backgroundColor: Colors.blue,
                child: Icon(Icons.edit, size: 10, color: Colors.white),
              ),
            ),
          ],
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                seller.shopName ?? "Nama Toko Belum Diatur",
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              Text(
                seller.shopAddress ?? "Lokasi Belum Diatur",
                style: const TextStyle(color: Colors.grey, fontSize: 13),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(Icons.star, color: Colors.orange, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    "4.9",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.grey.shade700),
                  ),
                  Text(
                    " • Baru",
                    style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
                  ),
                ],
              ),
            ],
          ),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SellerEditProfilePage()),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue.shade50,
            foregroundColor: Colors.blue,
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          ),
          child: const Text("Edit", style: TextStyle(fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }

  Widget _buildFinancialSection() {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade100),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("MONTHLY REVENUE", style: TextStyle(color: Colors.grey, fontSize: 11, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Rp 0", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  Icon(Icons.account_balance_wallet_outlined, color: Colors.grey.shade300, size: 30),
                ],
              ),
              const SizedBox(height: 4),
              const Text("Toko Baru Aktif", style: TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.w500)),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(child: _buildMiniSummaryCard("ORDERS", "0", "0% growth", Colors.grey)),
            const SizedBox(width: 12),
            Expanded(child: _buildMiniSummaryCard("PRODUCTS", "0", "Belum ada produk", Colors.blue)),
          ],
        )
      ],
    );
  }

  Widget _buildMiniSummaryCard(String title, String value, String subtitle, Color subColor) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(color: Colors.grey, fontSize: 11, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(subtitle, style: TextStyle(color: subColor, fontSize: 12, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildPerformanceChart() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Store Performance", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              Text("Last 7 Days", style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            height: 100,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: const Center(
              child: Text("Belum ada data performa minggu ini", style: TextStyle(color: Colors.grey, fontSize: 12)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInventoryList() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Text("Belum ada inventaris ikan hias", style: TextStyle(color: Colors.grey)),
      ),
    );
  }
}