import 'package:flutter/material.dart';
import '../../../../features/home/widgets/fish_card.dart';
import 'product_detail_page.dart';

class ProductPage extends StatefulWidget {
  // --- 1. TAMBAHKAN PARAMETER INI ---
  final Function(String)? onAddToCart;
  final String initialCategory; // <--- Tambahkan ini

  const ProductPage({
    super.key, 
    this.onAddToCart, 
    this.initialCategory = "Semua" // Defaultnya tetap "Semua"
  });


  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  // 1. Data sumber (Source of Truth)
  final List<Map<String, dynamic>> _products = [
    {"name": "Red Ryukin Goldfish", "price": "Rp25.000", "cat": "Koki", "rate": "4.8"},
    {"name": "Molly ballon calico", "price": "Rp25.000", "cat": "Molly", "rate": "4.9"},
    {"name": "Guppy HB White", "price": "Rp20.000", "cat": "Guppy", "rate": "4.5"},
    {"name": "Canister Filter CF-1200", "price": "Rp32.000", "cat": "Peralatan", "rate": "4.7"},
    {"name": "Pelet Akari Premium", "price": "Rp45.000", "cat": "Pakan Ikan", "rate": "4.9"},
  ];

  String _selectedCat = "Semua";

  @override
  Widget build(BuildContext context) {
    // 2. LOGIKA FILTER: Buat list baru berdasarkan kategori yang dipilih
    // Jika "Semua", ambil semua. Jika tidak, filter berdasarkan key 'cat'.
    final List<Map<String, dynamic>> filteredProducts = _selectedCat == "Semua"
        ? _products
        : _products.where((p) => p['cat'] == _selectedCat).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text("Semua Produk", 
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Search Bar (Tetap sama)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Cari jenis ikan..",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12), 
                  borderSide: BorderSide.none),
              ),
            ),
          ),
          
          // Category Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.all(16),
            child: Row(
              // 3. Tambahkan "Pakan Ikan" di daftar chip
              children: ["Semua","Arwana", "Koki", "Guppy", "Molly", "Peralatan", "Pakan Ikan"].map((cat) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(cat),
                    selected: _selectedCat == cat,
                    onSelected: (selected) {
                      setState(() {
                        _selectedCat = cat;
                      });
                    },
                    selectedColor: Colors.blue,
                    labelStyle: TextStyle(
                      color: _selectedCat == cat ? Colors.white : Colors.black),
                  ),
                );
              }).toList(),
            ),
          ),

          // Grid Produk
          Expanded(
            child: filteredProducts.isEmpty 
              ? const Center(child: Text("Produk tidak ditemukan")) 
              : GridView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.7,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  // 4. GUNAKAN HASIL FILTER DISINI
                  itemCount: filteredProducts.length,
                  itemBuilder: (context, index) {
                    final p = filteredProducts[index];
                    return GestureDetector(
                      onTap: () => Navigator.push(context, MaterialPageRoute(
                        builder: (context) => ProductDetailPage(
                          product: p,
                          onAddToCart: widget.onAddToCart, 
                        ),
                      )),
                      child: FishCard(
                        name: p['name'], 
                        price: p['price'], 
                        rating: p['rate'],
                        onTapAdd: () {
                          if (widget.onAddToCart != null) {
                            widget.onAddToCart!(p['name']);
                          }
                        },
                      ),
                    );
                  },
                ),
          ),
        ],
      ),
    );
  }
}