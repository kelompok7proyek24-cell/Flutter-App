// Path: lib/features/seller/presentation/pages/seller_dashboard_page.dart

import 'package:flutter/material.dart';
import 'seller_setting_page.dart'; // Import halaman setting agar terkoneksi
import 'package:ikanku/features/seller/data/models/product_model.dart';
import 'package:ikanku/features/seller/widgets/inventory_item_tile.dart';
import 'package:ikanku/features/seller/widgets/revenue_card.dart';

class SellerDashboardPage extends StatefulWidget {
  const SellerDashboardPage({super.key});

  @override
  State<SellerDashboardPage> createState() => _SellerDashboardPageState();
}

class _SellerDashboardPageState extends State<SellerDashboardPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF7F9FC),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // Kembali ke halaman profil utama pembeli
            Navigator.pop(context);
          },
        ),
        title: const Text(
          "Akun Seller",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none_outlined),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {
              // PERBAIKAN: Navigasi langsung terhubung ke Halaman Setting Seller
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SellerSettingPage(),
                ),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // =========================================
              // PROFIL TOKO CARD
              // =========================================
              _buildProfileCard(),
              const SizedBox(height: 20),

              // =========================================
              // METRIK FINANSIAL (REVENUE, ORDERS, PRODUCTS)
              // =========================================
              _buildFinancialSection(),
              const SizedBox(height: 20),

              // =========================================
              // GRAFIK PERFORMA TOKO (PLACEHOLDER)
              // =========================================
              _buildPerformanceChart(),
              const SizedBox(height: 24),

              // =========================================
              // DAFTAR INVENTARIS (INVENTORY)
              // =========================================
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Inventory (42 items)",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text("View All", style: TextStyle(color: Colors.blue)),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              _buildInventoryList(),
            ],
          ),
        ),
      ),
    );
  }

  // WIDGET: Profil Toko
  Widget _buildProfileCard() {
    return Row(
      children: [
        Stack(
          children: [
            CircleAvatar(
              radius: 32,
              backgroundColor: Colors.blue.shade900,
              child: const Icon(Icons.store, color: Colors.white, size: 30),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: CircleAvatar(
                radius: 10,
                backgroundColor: Colors.blue,
                child: const Icon(Icons.edit, size: 10, color: Colors.white),
              ),
            ),
          ],
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "AquaGrace",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const Text(
                "Premium Exotic Fish Store",
                style: TextStyle(color: Colors.grey, fontSize: 13),
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
                    " • Est. 2018",
                    style: TextStyle(color: Colors.grey.shade500, fontSize: 13),
                  ),
                ],
              ),
            ],
          ),
        ),
        ElevatedButton(
          onPressed: () {
            // PERBAIKAN: Tombol edit dialihkan juga ke Halaman Setting Seller
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const SellerSettingPage(),
              ),
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

  // WIDGET: Finansial & Summary Grid
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
                  const Text(
                    "Rp 154.200.500", 
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  Icon(Icons.account_balance_wallet_outlined, color: Colors.grey.shade300, size: 30),
                ],
              ),
              const SizedBox(height: 4),
              const Text("+8.5% dari bulan lalu", style: TextStyle(color: Colors.green, fontSize: 12, fontWeight: FontWeight.w500)),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(child: _buildMiniSummaryCard("ORDERS", "1,284", "+12% growth", Colors.green)),
            const SizedBox(width: 12),
            Expanded(child: _buildMiniSummaryCard("PRODUCTS", "42", "3 new this week", Colors.blue)),
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

  // WIDGET: Performance Chart
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
            // PERBAIKAN UTAMA: Menggunakan spaceBetween, bukan between
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _buildBarPlaceholder(40),
                _buildBarPlaceholder(30),
                _buildBarPlaceholder(50),
                _buildBarPlaceholder(45),
                _buildBarPlaceholder(35),
                _buildBarPlaceholder(20),
                _buildBarPlaceholder(80, isToday: true),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Mon", style: TextStyle(color: Colors.grey.shade400, fontSize: 11)),
              Text("Today", style: TextStyle(color: Colors.grey.shade600, fontSize: 11, fontWeight: FontWeight.bold)),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildBarPlaceholder(double heightPercentage, {bool isToday = false}) {
    return Container(
      width: 24,
      height: heightPercentage,
      decoration: BoxDecoration(
        color: isToday ? Colors.blue : Colors.grey.shade100,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(4),
          topRight: Radius.circular(4),
        ),
      ),
    );
  }

  // WIDGET: List Item Inventaris
  Widget _buildInventoryList() {
    final List<Map<String, dynamic>> items = [
      {"name": "Electric Blue Neon Tetra", "price": "Rp 4.500", "stock": "120 in stock", "status": "normal"},
      {"name": "Fancy Koi Angelfish", "price": "Rp 28.000", "stock": "15 in stock", "status": "warning"},
      {"name": "Red Dragon Betta", "price": "Rp 45.000", "stock": "Low: 2 units", "status": "danger"},
    ];

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.grey.shade100),
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.set_meal, color: Colors.blue),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item["name"], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(item["price"], style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 12)),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: item["status"] == "danger" ? Colors.red.shade50 : (item["status"] == "warning" ? Colors.orange.shade50 : Colors.green.shade50),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            item["stock"],
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: item["status"] == "danger" ? Colors.red : (item["status"] == "warning" ? Colors.orange : Colors.green),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.more_vert, color: Colors.grey),
                onPressed: () {},
              ),
            ],
          ),
        );
      },
    );
  }
}