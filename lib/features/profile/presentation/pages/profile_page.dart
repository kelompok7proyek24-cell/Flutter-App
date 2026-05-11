import 'package:flutter/material.dart';
import 'settings_page.dart';
import '../widgets/profile_menu_item.dart';
import '../widgets/order_status_card.dart';
import 'my_orders_page.dart'; // PASTIKAN SUDAH DI-IMPORT

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  // --- FUNGSI NAVIGASI BARU ---
  void _goToOrders(BuildContext context, int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MyOrdersPage(initialTab: index),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Akun saya",
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w600,
          ),
        ),
        automaticallyImplyLeading: false, 
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.black87),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SettingsPage()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 45,
              backgroundImage: NetworkImage('https://i.pravatar.cc/300'),
            ),
            const SizedBox(height: 12),
            const Text(
              "Azani Sakti SR", // Sesuai identitas user
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            const Text(
              "azani@gmail.com",
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 20),

            // --- KARTU PESANAN DENGAN LOGIKA NAVIGASI ---
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text(
                        "Pesanan Saya",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: () => _goToOrders(context, 0), // Buka Tab 0 (Semua)
                        child: const Text("Lihat Semua"),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      OrderStatusCard(
                        icon: Icons.wallet_giftcard,
                        title: "Dikemas",
                        onTap: () => _goToOrders(context, 1), // Buka Tab 1
                      ),
                      OrderStatusCard(
                        icon: Icons.local_shipping,
                        title: "Dikirim",
                        onTap: () => _goToOrders(context, 2), // Buka Tab 2
                      ),
                      OrderStatusCard(
                        icon: Icons.check_circle,
                        title: "Selesai",
                        onTap: () => _goToOrders(context, 3), // Buka Tab 3
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Menu List Tetap Sama
            ProfileMenuItem(
              icon: Icons.favorite_border,
              title: "Disukai",
              subtitle: "12 Items Saved",
              onTap: () {},
            ),
            ProfileMenuItem(
              icon: Icons.location_on_outlined,
              title: "Alamat Pengiriman",
              subtitle: "Home, Office",
              onTap: () {},
            ),
            ProfileMenuItem(
              icon: Icons.credit_card,
              title: "Metode Pembayaran",
              subtitle: "Visa ****4242",
              onTap: () {},
            ),
            ProfileMenuItem(
              icon: Icons.chat_bubble_outline,
              title: "Pesan",
              subtitle: "Tidak Ada Pesan",
              onTap: () {},
            ),
            const SizedBox(height: 30),

            // Tombol Keluar
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade50,
                  foregroundColor: Colors.red,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                onPressed: () {},
                icon: const Icon(Icons.logout),
                label: const Text("Keluar"),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}