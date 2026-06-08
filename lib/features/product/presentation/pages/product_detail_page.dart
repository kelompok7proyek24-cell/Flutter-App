import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/constants/colors.dart';

// IMPORT DATA TERPUSAT: Menghubungkan tipe data ke arsitektur ProductModel
import '../../../seller/data/models/product_model.dart';
import 'package:ikanku/features/cart/presentation/controllers/cart_controller.dart';
import 'package:ikanku/features/cart/presentation/pages/cart_page.dart';

class ProductDetailPage extends StatefulWidget {
  final ProductModel product;
  final Function(String)? onAddToCart;

  const ProductDetailPage({
    super.key, 
    required this.product, 
    this.onAddToCart,
  });

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  String selectedVariant = ""; 
  int quantity = 1; // Menyimpan jumlah pesanan lokal sebelum masuk ke keranjang

  @override
  Widget build(BuildContext context) {
    // Memeriksa tipe produk berdasarkan kategorinya
    final isFish = ["Arwana", "Koki", "Guppy", "Molly"].contains(widget.product.category);

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          // 1. Sliver AppBar Dinamis (Menampilkan Gambar Asli Produk)
          SliverAppBar(
            expandedHeight: 350,
            pinned: true,
            backgroundColor: Colors.white,
            elevation: 0,
            leading: const BackButton(color: Colors.black),
            actions: [
              IconButton(onPressed: () {}, icon: const Icon(Icons.favorite_border, color: Colors.black)),
              IconButton(onPressed: () {}, icon: const Icon(Icons.share, color: Colors.black)),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                color: Colors.grey[100],
                // Render gambar sesuai path yang didefinisikan pada ProductModel
                child: Image.asset(
                  widget.product.imagePath,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const Center(
                      child: Icon(Icons.broken_image, size: 64, color: Colors.grey),
                    );
                  },
                ), 
              ),
            ),
          ),

          // 2. Konten Detail Informasi Produk
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nama Produk Dinamis
                  Text(
                    widget.product.name, 
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  
                  // Harga Produk Dinamis (Format Rupiah)
                  Text(
                    "Rp ${widget.product.price.toStringAsFixed(0)}", 
                    style: const TextStyle(fontSize: 20, color: AppColors.primaryBlue, fontWeight: FontWeight.bold),
                  ),
                  
                  const SizedBox(height: 25),

                  // 3. Card Penjual
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade200),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      children: [
                        const CircleAvatar(radius: 20, backgroundColor: AppColors.primaryBlue),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text("AquaGrace", style: TextStyle(fontWeight: FontWeight.bold)),
                                  SizedBox(width: 5),
                                  Icon(Icons.check_circle, size: 14, color: AppColors.primaryBlue),
                                ],
                              ),
                              Text("Indramayu Kota", style: TextStyle(fontSize: 12, color: Colors.grey)),
                            ],
                          ),
                        ),
                        OutlinedButton(onPressed: () {}, child: const Text("Kunjungi")),
                      ],
                    ),
                  ),

                  // 4. Logika Kondisional Pemilihan Varian (Hanya muncul jika jenis produk = Ikan)
                  if (isFish) ...[
                    const SizedBox(height: 25),
                    const Text("Pilih Jenis Kelamin", style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    Row(
                      children: ["Jantan", "Betina", "Sepasang"].map((variant) {
                        final isSelected = selectedVariant == variant;
                        return Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: ChoiceChip(
                            label: Text(variant),
                            selected: isSelected,
                            onSelected: (val) => setState(() => selectedVariant = variant),
                            selectedColor: AppColors.primaryBlue,
                            labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.black),
                          ),
                        );
                      }).toList(),
                    ),
                  ],

                  const SizedBox(height: 25),

                  // --- FITUR BARU: ATUR KUANTITAS SEBELUM MASUK KERANJANG ---
                  const Text("Jumlah Pembelian", style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove, size: 18),
                              onPressed: () {
                                if (quantity > 1) {
                                  setState(() => quantity--);
                                }
                              },
                            ),
                            Text(
                              "$quantity",
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            IconButton(
                              icon: const Icon(Icons.add, size: 18, color: AppColors.primaryBlue),
                              onPressed: () {
                                setState(() => quantity++);
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 15),
                      Text(
                        "Total: Rp ${(widget.product.price * quantity).toStringAsFixed(0)}",
                        style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  // 5. Deskripsi Produk Dinamis
                  const Text("DESKRIPSI PRODUK", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, letterSpacing: 1.1)),
                  const Divider(),
                  Text(
                    widget.product.description,
                    style: const TextStyle(color: Colors.black87, height: 1.5, fontSize: 14),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      
      // 6. Bottom Navigation Bar (Sistem Transaksi & Keranjang)
      bottomNavigationBar: Container(
        height: 80,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Colors.black12)),
        ),
        child: Row(
          children: [
            IconButton(
              onPressed: () {}, 
              icon: const Icon(Icons.chat_outlined, color: AppColors.primaryBlue),
            ),
            
            // Perbaikan Tombol Tambah ke Keranjang Terintegrasi Global State & Local Storage
            IconButton(
              onPressed: () async {
                // Simpan data quantity ke SharedPreferences disk agar CartPage sinkron
                final prefs = await SharedPreferences.getInstance();
                int existingQty = prefs.getInt('cart_qty_${widget.product.id}') ?? 0;
                await prefs.setInt('cart_qty_${widget.product.id}', existingQty + quantity);

                // Menyuntikkan data produk ke dalam data list CartController global (In-Memory)
                for (int i = 0; i < quantity; i++) {
                  CartController().addToCart(
                    id: widget.product.id ?? widget.product.name.hashCode.toString(), 
                    name: widget.product.name, 
                    price: widget.product.price.toInt(), 
                    image: widget.product.imagePath,
                  );
                }

                // Jalankan callback bawaan jika ada
                if (widget.onAddToCart != null) {
                  widget.onAddToCart!(widget.product.name);
                }

                // Tampilkan notifikasi berhasil ke user
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("$quantity ${widget.product.name} berhasil ditambahkan ke keranjang!"),
                      backgroundColor: AppColors.primaryBlue,
                      duration: const Duration(seconds: 2),
                    ),
                  );
                }
              }, 
              icon: const Icon(Icons.add_shopping_cart, color: AppColors.primaryBlue),
            ),
            
            const SizedBox(width: 10),
            
            // Perbaikan Tombol Beli Sekarang: Menulis ke SharedPreferences lalu Navigasi Langsung
            Expanded(
              child: ElevatedButton(
                onPressed: () async {
                  // 1. Tulis data ke SharedPreferences agar terbaca di CartPage
                  final prefs = await SharedPreferences.getInstance();
                  int existingQty = prefs.getInt('cart_qty_${widget.product.id}') ?? 0;
                  await prefs.setInt('cart_qty_${widget.product.id}', existingQty + quantity);

                  // 2. Sinkronisasi cadangan ke CartController objek
                  for (int i = 0; i < quantity; i++) {
                    CartController().addToCart(
                      id: widget.product.id ?? widget.product.name.hashCode.toString(), 
                      name: widget.product.name, 
                      price: widget.product.price.toInt(), 
                      image: widget.product.imagePath,
                    );
                  }

                  // 3. Arahkan user menuju halaman keranjang
                  if (context.mounted) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CartPage(),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryBlue,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text(
                  "Beli Sekarang", 
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}