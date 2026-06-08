import 'package:flutter/material.dart';
import '../../../../core/constants/colors.dart';
import 'package:ikanku/features/profile/presentation/pages/profile_page.dart';
import 'package:ikanku/features/profile/presentation/pages/settings_page.dart';
import 'package:ikanku/features/product/presentation/pages/product_page.dart';
import 'package:ikanku/features/cart/presentation/pages/cart_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

// IMPORT MODUL SELLER: Menghubungkan data dummy produk dari modul seller
import '../../../seller/data/models/product_model.dart';
import 'package:ikanku/features/product/presentation/pages/product_detail_page.dart';

// =========================================================================
// PERBAIKAN ARSITEKTUR: Mengimpor Fitur Artikel Terpusat (Data & UI Halaman)
// =========================================================================
import 'package:ikanku/features/article/data/models/article_model.dart';
import 'package:ikanku/features/article/presentation/pages/article_page.dart';
import 'package:ikanku/features/article/presentation/pages/article_detail_page.dart';
import 'package:ikanku/features/article/presentation/pages/edit_article_page.dart';

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
    
    if (!mounted) return;
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
    // SINKRONISASI HALAMAN: Mengarahkan Tab index ke-2 ke halaman ArticlePage yang baru dibuat
    final List<Widget> pages = [
      _buildHomeContent(), 
      ProductPage(onAddToCart: _incrementCart), 
      const ArticlePage(), // <-- Terhubung ke halaman daftar edukasi utama
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
            // Header Utama
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
                  // =========================================================================
                  // PERBAIKAN: Membungkus ikon keranjang agar langsung membuka halaman CartPage
                  // =========================================================================
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _currentIndex = 3; // Pindah langsung ke tab indeks 3 (CartPage)
                      });
                    },
                    child: Stack(
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
                  ),
                ],
              ),
            ),

            // Search Bar
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

            // Kotak Banner Promo
            Container(
              margin: const EdgeInsets.all(16.0),
              height: 150,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.asset(
                  "assets/images/banner_home.png", 
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [AppColors.primaryBlue, Colors.lightBlue],
                        ),
                      ),
                      child: const Center(
                        child: Text(
                          "PROMO EKSPO", 
                          style: TextStyle(
                            color: Colors.white, 
                            fontSize: 24, 
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            // Produk Unggulan Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Produk Unggulan", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  TextButton(
                    onPressed: () {
                      setState(() => _currentIndex = 1);
                    },
                    child: const Text("View All", style: TextStyle(color: AppColors.primaryBlue, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),

            // Grid Layout Produk Unggulan (Bisa Di-klik ke Detail)
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: dummyProducts.length > 4 ? 4 : dummyProducts.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.73,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemBuilder: (context, index) {
                final product = dummyProducts[index];
                return InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductDetailPage(
                          product: product,
                          onAddToCart: _incrementCart,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: const BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),
                            child: Image.asset(
                              product.imagePath,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: Colors.grey[200], 
                                  child: const Icon(Icons.broken_image, color: Colors.grey)
                                );
                              },
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                product.description,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontSize: 11, color: Colors.grey),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                "Rp ${product.price.toStringAsFixed(0)}",
                                style: const TextStyle(color: AppColors.primaryBlue, fontWeight: FontWeight.bold, fontSize: 13),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

            // =========================================
            // INTEGRASI LINK: 3 ARTIKEL TIPS PERAWATAN
            // =========================================
            const Padding(
              padding: EdgeInsets.only(left: 16, right: 16, top: 24, bottom: 12),
              child: Text("Tips Perawatan", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
            
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: dummyArticles.length, // Membaca data dummy global dari modul article
              itemBuilder: (context, index) {
                final article = dummyArticles[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey.shade200),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () {
                      // Navigasi ke Halaman Detail Bacaan Artikel ketika Card diklik
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ArticleDetailPage(article: article),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: article.imagePath.isNotEmpty
                                ? Image.asset(article.imagePath, width: 60, height: 60, fit: BoxFit.cover)
                                : Container(
                                    width: 60,
                                    height: 60,
                                    color: Colors.green[50],
                                    child: const Icon(Icons.eco, color: Colors.green),
                                  ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(article.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                                const SizedBox(height: 2),
                                Text(article.subtitle, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.edit_note, color: Colors.grey, size: 22),
                            onPressed: () {
                              // Slot Navigasi Form Update (Akan ditangani di tahap pembuatan Edit Halaman)
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}