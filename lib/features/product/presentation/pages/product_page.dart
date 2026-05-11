import 'package:flutter/material.dart';
import '../../../../features/home/widgets/fish_card.dart';
import 'product_detail_page.dart';

class ProductPage extends StatefulWidget {
  // --- 1. TAMBAHKAN PARAMETER INI ---
  final Function(String)? onAddToCart;
  
  const ProductPage({super.key, this.onAddToCart});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  final List<Map<String, dynamic>> _products = [
    {"name": "Red Ryukin Goldfish", "price": "Rp25.000", "cat": "Koki", "rate": "4.8"},
    {"name": "Molly ballon calico", "price": "Rp25.000", "cat": "Molly", "rate": "4.9"},
    {"name": "Guppy HB White", "price": "Rp20.000", "cat": "Guppy", "rate": "4.5"},
    {"name": "Canister Filter CF-1200", "price": "Rp32.000", "cat": "Aquarium set", "rate": "4.7"},
  ];

  String _selectedCat = "Semua";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text("Semua Produk", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Cari jenis ikan..",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              ),
            ),
          ),
          
          // Category Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.all(16),
            child: Row(
              children: ["Semua", "Koki", "Guppy", "Molly", "Peralatan"].map((cat) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(cat),
                    selected: _selectedCat == cat,
                    onSelected: (selected) => setState(() => _selectedCat = cat),
                    selectedColor: Colors.blue,
                    labelStyle: TextStyle(color: _selectedCat == cat ? Colors.white : Colors.black),
                  ),
                );
              }).toList(),
            ),
          ),

          // Grid Produk
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.7,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: _products.length,
              itemBuilder: (context, index) {
                final p = _products[index];
                return GestureDetector(
                  onTap: () => Navigator.push(context, MaterialPageRoute(
                    builder: (context) => ProductDetailPage(
                      product: p,
                      // --- 2. KIRIM JUGA FUNGSI INI KE DETAIL PAGE ---
                      onAddToCart: widget.onAddToCart, 
                    ),
                  )),
                  child: FishCard(
                    name: p['name'], 
                    price: p['price'], 
                    rating: p['rate'],
                    // --- 3. HUBUNGKAN TOMBOL + DISINI ---
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