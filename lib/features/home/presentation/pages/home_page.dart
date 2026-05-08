import 'package:flutter/material.dart';
import 'package:ikanku/features/home/widgets/fish_card.dart' show FishCard;
import '../../../../core/constants/colors.dart';
import 'package:ikanku/features/profile/presentation/pages/profile_page.dart'; // Import halaman profil
import 'package:ikanku/features/profile/presentation/pages/settings_page.dart'; // Import halaman settings
import 'package:ikanku/features/home/widgets/fish_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // 1. Variabel untuk melacak index halaman aktif
  int _currentIndex = 0;

  // 2. Daftar halaman yang akan ditampilkan
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      _buildHomeContent(), // Index 0: Konten Beranda
      const Center(child: Text("Halaman Produk")), // Index 1
      const Center(child: Text("Halaman Artikel")), // Index 2
      const Center(child: Text("Halaman Keranjang")), // Index 3
      const ProfilePage(), // Index 4: Halaman Akun
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // 3. Body akan berganti sesuai index yang dipilih
      body: _pages[_currentIndex],
      
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.primaryBlue,
        unselectedItemColor: Colors.grey,
        currentIndex: _currentIndex, // Index yang sedang aktif
        onTap: (index) {
          setState(() {
            _currentIndex = index; // Ubah halaman saat tombol ditekan
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

  // 4. Kita pindahkan konten beranda ke fungsi terpisah agar rapi
  Widget _buildHomeContent() {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  // TOMBOL GERIGI TERKONEKSI KE SETTINGS
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
                  const Stack(
                    children: [
                      Icon(Icons.shopping_cart_outlined, color: AppColors.primaryBlue),
                      Positioned(
                        right: 0,
                        child: CircleAvatar(radius: 6, backgroundColor: Colors.red, child: Text("2", style: TextStyle(fontSize: 8, color: Colors.white))),
                      )
                    ],
                  ),
                ],
              ),
            ),

            // Search Bar
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

            // Banner
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

            // Section Produk
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

            // List Produk
            SizedBox(
              height: 220,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.only(left: 16),
                children: const [
                  FishCard(name: "Red Ryukin Goldfish", price: "Rp25.000", rating: "4.8"),
                  FishCard(name: "Red Ryukin Goldfish", price: "Rp25.000", rating: "4.8"),
                ],
              ),
            ),

            // Artikel Section
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