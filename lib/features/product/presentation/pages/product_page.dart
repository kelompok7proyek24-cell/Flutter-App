import 'package:flutter/material.dart';
import 'package:ikanku/features/home/widgets/fish_card.dart'; // Pastikan path widget FishCard benar
import '../../../../core/constants/colors.dart';

// 1. Model Data Produk (Bisa dipindah ke folder data/models nanti)
class Product {
  final String id;
  final String name;
  final String category;
  final int price;
  final double rating;
  final String imageUrl;

  Product({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.rating,
    required this.imageUrl,
  });
}

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  // 2. Data Dummy (Nantinya diganti dengan data dari API Express.js)
  final List<Product> _allProducts = [
    Product(id: "1", name: "Red Ryukin Goldfish", category: "Koki", price: 25000, rating: 4.8, imageUrl: ""),
    Product(id: "2", name: "Molly Balon Calico", category: "Molly", price: 15000, rating: 4.5, imageUrl: ""),
    Product(id: "3", name: "Guppy Albino White", category: "Guppy", price: 20000, rating: 4.9, imageUrl: ""),
    Product(id: "4", name: "Aquarium Set Nano", category: "Aquarium", price: 350000, rating: 4.7, imageUrl: ""),
    Product(id: "5", name: "Calico Teleskop Eye", category: "Koki", price: 35000, rating: 4.6, imageUrl: ""),
    Product(id: "6", name: "Molly Black Platinum", category: "Molly", price: 24000, rating: 4.8, imageUrl: ""),
  ];

  // State untuk filtering
  List<Product> _filteredProducts = [];
  String _selectedCategory = "Semua";
  final TextEditingController _searchController = TextEditingController();

  final List<String> _categories = ["Semua", "Koki", "Guppy", "Molly", "Aquarium"];

  @override
  void initState() {
    super.initState();
    _filteredProducts = _allProducts; // Inisialisasi awal tampilkan semua
  }

  // 3. Logika Filtering & Search
  void _runFilter() {
    setState(() {
      _filteredProducts = _allProducts.where((product) {
        final matchesSearch = product.name.toLowerCase().contains(_searchController.text.toLowerCase());
        final matchesCategory = _selectedCategory == "Semua" || product.category == _selectedCategory;
        return matchesSearch && matchesCategory;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Semua Produk",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.shopping_cart_outlined, color: Colors.blue),
          )
        ],
      ),
      body: Column(
        children: [
          // 4. Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              onChanged: (value) => _runFilter(), // Panggil filter saat mengetik
              decoration: InputDecoration(
                hintText: "Cari ikan terbaikmu..",
                prefixIcon: const Icon(Icons.search),
                suffixIcon: Container(
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.circular(8)),
                  child: const Icon(Icons.tune, color: Colors.white, size: 20),
                ),
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
              ),
            ),
          ),

          // 5. Category Chips (Horizontal Scroll)
          SizedBox(
            height: 40,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final category = _categories[index];
                final isSelected = _selectedCategory == category;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(category),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        _selectedCategory = category;
                        _runFilter();
                      });
                    },
                    selectedColor: Colors.blue,
                    labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.black),
                    backgroundColor: Colors.grey[100],
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  ),
                );
              },
            ),
          ),

          // 6. Header Grid (Showing results)
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Showing ${_filteredProducts.length} results",
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
                const Row(
                  children: [
                    Text("Sort: Featured", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                    Icon(Icons.keyboard_arrow_down, size: 16),
                  ],
                ),
              ],
            ),
          ),

          // 7. Grid Produk
          Expanded(
            child: _filteredProducts.isEmpty
                ? const Center(child: Text("Produk tidak ditemukan"))
                : GridView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // 2 kolom sesuai gambar
                      childAspectRatio: 0.72, // Mengatur tinggi kartu
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    itemCount: _filteredProducts.length,
                    itemBuilder: (context, index) {
                      final product = _filteredProducts[index];
                      return FishCard(
                        name: product.name,
                        price: "Rp${product.price}",
                        rating: product.rating.toString(),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}