import 'package:flutter/material.dart';

class ProductDetailPage extends StatefulWidget {
  final Map<String, dynamic> product;
  // 1. TAMBAHKAN: Parameter callback untuk sinkronisasi ke HomePage
  final Function(String)? onAddToCart;

  const ProductDetailPage({
    super.key, 
    required this.product, 
    this.onAddToCart, // Tambahkan di constructor
  });

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  String selectedVariant = ""; 
  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          // 1. Sliver AppBar (Visual Tetap Sama)
          SliverAppBar(
            expandedHeight: 400,
            pinned: true,
            backgroundColor: Colors.white,
            leading: const BackButton(color: Colors.black),
            actions: [
              IconButton(onPressed: () {}, icon: const Icon(Icons.favorite_border, color: Colors.black)),
              IconButton(onPressed: () {}, icon: const Icon(Icons.share, color: Colors.black)),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                color: Colors.grey[100],
                child: const Center(child: Icon(Icons.set_meal, size: 100, color: Colors.blueAccent)), 
              ),
            ),
          ),

          // 2. Konten Detail
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.product['name'], style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(widget.product['price'], style: const TextStyle(fontSize: 22, color: Colors.blue, fontWeight: FontWeight.bold)),
                  
                  const SizedBox(height: 25),

                  // 3. Card Penjual (AquaGrace)
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade200),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      children: [
                        const CircleAvatar(radius: 20, backgroundColor: Colors.blue),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text("AquaGrace", style: TextStyle(fontWeight: FontWeight.bold)),
                                  SizedBox(width: 5),
                                  Icon(Icons.check_circle, size: 14, color: Colors.blue),
                                ],
                              ),
                              Text("Tangerang Selatan", style: TextStyle(fontSize: 12, color: Colors.grey)),
                            ],
                          ),
                        ),
                        OutlinedButton(onPressed: () {}, child: const Text("Kunjungi")),
                      ],
                    ),
                  ),

                  const SizedBox(height: 25),

                  // 4. Pemilihan Varian
                  const Text("Pilih Jenis Kelamin", style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Row(
                    children: ["Jantan", "Betina"].map((variant) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: ChoiceChip(
                          label: Text(variant),
                          selected: selectedVariant == variant,
                          onSelected: (val) => setState(() => selectedVariant = variant),
                        ),
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 30),

                  // 5. Deskripsi Produk
                  const Text("DESKRIPSI PRODUK", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const Divider(),
                  const Text(
                    "Ikan Koki Oranda kualitas kontes dengan sisik mengkilap. Sehat, lincah, dan sudah melalui proses karantina. Cocok untuk penghobi profesional.",
                    style: TextStyle(color: Colors.grey, height: 1.5),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      
      // 6. Bottom Bar (Koneksi ke Sistem Keranjang)
      bottomNavigationBar: Container(
        height: 80,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Colors.black12)),
        ),
        child: Row(
          children: [
            IconButton(onPressed: () {}, icon: const Icon(Icons.chat_outlined, color: Colors.blue)),
            
            // 2. PERBAIKAN: Tombol Tambah Keranjang
            IconButton(
              onPressed: () {
                if (widget.onAddToCart != null) {
                  widget.onAddToCart!(widget.product['name']);
                }
              }, 
              icon: const Icon(Icons.add_shopping_cart, color: Colors.blue)
            ),
            
            const SizedBox(width: 10),
            
            // 3. PERBAIKAN: Tombol Beli Sekarang
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  if (widget.onAddToCart != null) {
                    widget.onAddToCart!(widget.product['name']);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text("Beli Sekarang", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}