import 'package:flutter/material.dart';
import 'package:ikanku/features/home/widgets/fish_card.dart'; 
import '../../../../core/constants/colors.dart';
import 'package:ikanku/features/profile/presentation/pages/profile_page.dart';
import 'package:ikanku/features/profile/presentation/pages/settings_page.dart';
import 'package:ikanku/features/product/presentation/pages/product_page.dart';
import 'package:ikanku/features/cart/presentation/pages/cart_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  int _cartCount = 0;

  @override
  void initState() {
    super.initState();
    _loadCartCount();
  }

  // Mengambil data agar badge keranjang tetap sinkron
  void _loadCartCount() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _cartCount = prefs.getInt('cart_count') ?? 0;
    });
  }

  void _incrementCart(String productName) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _cartCount++;
    });
    await prefs.setInt('cart_count', _cartCount);
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("$productName berhasil ditambah ke keranjang"),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // PERBAIKAN LOGIKA: Pindah tab sekaligus kirim kategori
  void _navigateToCategory(String categoryName) {
    // 1. Update index tab agar saat kembali, user berada di tab produk
    setState(() {
      _currentIndex = 1; 
    });
    
    // 2. Navigasi ke halaman produk dengan filter awal
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductPage(
          onAddToCart: _incrementCart,
          // Pastikan variabel ini diterima di ProductPage
          initialCategory: categoryName, 
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // List halaman utama
    final List<Widget> pages = [
      _buildHomeContent(), 
      ProductPage(onAddToCart: _incrementCart), 
      const Center(child: Text("Halaman Artikel")), 
      const CartPage(), 
      const ProfilePage(), 
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.primaryBlue,
        unselectedItemColor: Colors.grey,
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
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
            // Header
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingsPage())),
                    child: const Icon(Icons.settings_outlined, color: AppColors.primaryBlue),
                  ),
                  const Expanded(
                    child: Center(
                      child: Text("IKANKU.ID", style: TextStyle(color: AppColors.primaryBlue, fontWeight: FontWeight.bold, fontSize: 18)),
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
                            child: Text("$_cartCount", style: const TextStyle(fontSize: 8, color: Colors.white, fontWeight: FontWeight.bold))
                          ),
                        )
                    ],
                  ),
                ],
              ),
            ),

            // Search Bar (Redirect ke Produk)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextField(
                readOnly: true, 
                onTap: () => setState(() => _currentIndex = 1),
                decoration: InputDecoration(
                  hintText: "Cari ikan terbaikmu..",
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.grey[100],
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                ),
              ),
            ),

            // Banner Promo
            Container(
              margin: const EdgeInsets.all(16.0),
              height: 150,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [AppColors.primaryBlue, Colors.lightBlue]),
                borderRadius: BorderRadius.circular(15),
              ),
              child: const Center(
                child: Text("PROMO EKSPO", style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
              ),
            ),

            // Bagian Kategori Pilihan
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text("Kategori Pilihan", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 12),
            
            SizedBox(
              height: 100,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.only(left: 16),
                children: [
                  _buildCategoryBox("Molly", Icons.set_meal, Colors.orange[100]!),
                  _buildCategoryBox("Koki", Icons.bakery_dining, Colors.red[100]!),
                  _buildCategoryBox("Guppy", Icons.waves, Colors.blue[100]!),
                  _buildCategoryBox("Peralatan", Icons.handyman, Colors.green[100]!),
                  _buildCategoryBox("Pakan Ikan", Icons.grain, Colors.purple[100]!),
                ],
              ),
            ),

            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text("Tips Perawatan", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
            _buildArticleCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryBox(String title, IconData icon, Color color) {
    return GestureDetector(
      onTap: () => _navigateToCategory(title),
      child: Container(
        width: 85,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.black54, size: 30),
            const SizedBox(height: 8),
            Text(title, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }

  Widget _buildArticleCard() {
    return Container(
      margin: const EdgeInsets.only(left: 16, right: 16, bottom: 20), 
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Container(
              width: 60, 
              height: 60, 
              color: Colors.green[50], 
              child: const Icon(Icons.eco, color: Colors.green)
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Menjaga Ekosistem Akuarium", style: TextStyle(fontWeight: FontWeight.bold)),
                Text("Cara mudah mengatur pH air untuk ikan hias.", style: TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}