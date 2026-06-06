import 'package:flutter/material.dart';
import '../../../../core/constants/colors.dart';
import 'package:ikanku/features/profile/presentation/pages/profile_page.dart';
import 'package:ikanku/features/profile/presentation/pages/settings_page.dart';
import 'package:ikanku/features/product/presentation/pages/product_page.dart';
import 'package:ikanku/features/cart/presentation/pages/cart_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

// IMPORT: Menghubungkan data dummy produk ikan hias dari modul seller
import '../../../seller/data/models/product_model.dart';

// DATA MODEL ARTIKEL: Agar struktur data 3 artikel seragam dan siap di-edit
class ArticleModel {
  final String id;
  final String title;
  final String subtitle;
  final String imagePath;

  ArticleModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.imagePath,
  });
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  int _cartCount = 0;

  // PERBAIKAN: Jalur gambar dikosongkan agar beralih ke icon eco bawaan (bukan banner lagi)
  final List<ArticleModel> _dummyArticles = [
    ArticleModel(
      id: "a1",
      title: "Menjaga Ekosistem Akuarium",
      subtitle: "Cara mudah mengatur pH air untuk ikan hias.",
      imagePath: "", 
    ),
    ArticleModel(
      id: "a2",
      title: "Nutrisi Tepat Ikan Arwana",
      subtitle: "Jenis pakan alami untuk mempercepat mutasi warna merah.",
      imagePath: "", 
    ),
    ArticleModel(
      id: "a3",
      title: "Budidaya Cepat Ikan Guppy",
      subtitle: "Panduan dasar mengawinkan indukan guppy strain murni.",
      imagePath: "", 
    ),
  ];

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

// =========================================
            // PERBAIKAN KOTAK BANNER: AMAN DARI ERROR GRADIENT
            // =========================================
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
                  "assets/images/banner_home.png", // Memanggil file gambar banner utama
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    // Proteksi sistem: Gradient dipindahkan ke dalam BoxDecoration agar sintaksis valid
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

            // =========================================
            // MODIFIKASI 1: PRODUK UNGGULAN & VIEW ALL
            // =========================================
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

            // Grid Layout untuk menampilkan item ikan hias (Arwana, Molly, Koki, Guppy)
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
                return Container(
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
                );
              },
            ),

            // =========================================
            // MODIFIKASI 2: 3 ARTIKEL TIPS PERAWATAN
            // =========================================
            const Padding(
              padding: EdgeInsets.only(left: 16, right: 16, top: 24, bottom: 12),
              child: Text("Tips Perawatan", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
            
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _dummyArticles.length,
              itemBuilder: (context, index) {
                final article = _dummyArticles[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
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
                        child: Image.asset(
                          article.imagePath,
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Container(
                            width: 60,
                            height: 60,
                            color: Colors.green[50],
                            // Mengembalikan visual ke ikon daun default yang bersih
                            child: const Icon(Icons.eco, color: Colors.green),
                          ),
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
                          // Tempat integrasi navigasi form update data artikel
                        },
                      ),
                    ],
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