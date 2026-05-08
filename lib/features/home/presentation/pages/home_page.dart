import 'package:flutter/material.dart';
import 'package:ikanku/features/home/widgets/fish_card.dart'; 
import '../../../../core/constants/colors.dart';
import 'package:ikanku/features/profile/presentation/pages/profile_page.dart';
import 'package:ikanku/features/profile/presentation/pages/settings_page.dart';
import 'package:ikanku/features/product/presentation/pages/product_page.dart';
import 'package:ikanku/features/cart/presentation/pages/cart_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  int _cartCount = 2; // Angka awal keranjang

  void _incrementCart(String productName) {
    setState(() {
      _cartCount++;
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("$productName berhasil ditambah ke keranjang"),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // --- PINDAHKAN LIST PAGES KE SINI AGAR REAKTIF ---
    final List<Widget> pages = [
      _buildHomeContent(), 
      ProductPage(onAddToCart: _incrementCart), 
      const Center(child: Text("Halaman Artikel")), 
      const CartPage(), 
      const ProfilePage(), 
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: pages[_currentIndex], // Menggunakan variabel lokal pages
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.primaryBlue,
        unselectedItemColor: Colors.grey,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_bag), label: 'Produk'),
          BottomNavigationBarItem(icon: Icon(Icons.article), label: 'Artikel'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Keranjang'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Akun'),
        ],
      ),
    );
  }

  Widget _buildHomeContent() {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header dengan Badge yang reaktif
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const SettingsPage()),
                      );
                    },
                    child: const Icon(Icons.settings_outlined, color: AppColors.primaryBlue),
                  ),
                  const Expanded(
                    child: Center(
                      child: Text("IKANKU.ID", 
                        style: TextStyle(color: AppColors.primaryBlue, fontWeight: FontWeight.bold, fontSize: 18)),
                    ),
                  ),
                  
                  Stack(
                    children: [
                      const Icon(Icons.shopping_cart_outlined, color: AppColors.primaryBlue),
                      if (_cartCount > 0)
                        Positioned(
                          right: 0,
                          child: CircleAvatar(
                            radius: 6, 
                            backgroundColor: Colors.red, 
                            child: Text(
                              "$_cartCount", 
                              style: const TextStyle(fontSize: 8, color: Colors.white, fontWeight: FontWeight.bold)
                            )
                          ),
                        )
                    ],
                  ),
                ],
              ),
            ),

            // Search Bar & Banner (Tetap sama)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Cari ikan terbaikmu..",
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.grey[100],
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                ),
              ),
            ),

            Container(
              margin: const EdgeInsets.all(16.0),
              height: 150,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.primaryBlue,
                borderRadius: BorderRadius.circular(15),
              ),
              child: const Center(
                child: Text("IKANKU.ID", style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
              ),
            ),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Produk unggulan", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  Text("Lebih banyak", style: TextStyle(color: AppColors.primaryBlue, fontSize: 12)),
                ],
              ),
            ),

            // List Produk Horizontal di Beranda
            SizedBox(
              height: 220,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.only(left: 16),
                children: [
                  FishCard(
                    name: "Red Ryukin Goldfish", 
                    price: "Rp25.000", 
                    rating: "4.8",
                    onTapAdd: () => _incrementCart("Red Ryukin Goldfish"),
                  ),
                  FishCard(
                    name: "Red Ryukin Goldfish", 
                    price: "Rp25.000", 
                    rating: "4.8",
                    onTapAdd: () => _incrementCart("Red Ryukin Goldfish"),
                  ),
                ],
              ),
            ),

            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text("Perawatan ikan", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
            
            _buildArticleCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildArticleCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Container(width: 60, height: 60, color: Colors.green[200], child: const Icon(Icons.eco)),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("5 Tips for a Perfect Tank Ecosystem", style: TextStyle(fontWeight: FontWeight.bold)),
                Text("Learn how to balance pH and nitrate levels easily.", style: TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}