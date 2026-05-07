// profile_page.dart

import 'package:flutter/material.dart';
import 'settings_page.dart';
import 'edit_profile_page.dart';
import '../widgets/profile_menu_item.dart';
import '../widgets/order_status_card.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Akun saya",
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87),
          onPressed: () {},
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.black87),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const SettingsPage(),
                ),
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
              backgroundImage: NetworkImage(
                'https://i.pravatar.cc/300',
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              "Adifis",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              "azani.idta@gmail.com",
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 20),

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
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: () {},
                        child: const Text("Lihat Semua"),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      OrderStatusCard(
                        icon: Icons.wallet_giftcard,
                        title: "Dikemas",
                      ),
                      OrderStatusCard(
                        icon: Icons.local_shipping,
                        title: "Dikirim",
                      ),
                      OrderStatusCard(
                        icon: Icons.check_circle,
                        title: "Selesai",
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

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

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade50,
                  foregroundColor: Colors.red,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: () {},
                icon: const Icon(Icons.logout),
                label: const Text("Keluar"),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 4,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Beranda",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag),
            label: "Produk",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.article),
            label: "Artikel",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: "Keranjang",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Akun",
          ),
        ],
      ),
    );
  }
}