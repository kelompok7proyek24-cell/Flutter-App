import 'package:flutter/material.dart';
import '../../../../core/constants/colors.dart';
import 'product_detail_page.dart';

// IMPORT DATA TERPUSAT: Menghubungkan Source of Truth dari modul seller
import '../../../seller/data/models/product_model.dart';

class ProductPage extends StatefulWidget {
  final Function(String)? onAddToCart;
  final String initialCategory;

  const ProductPage({
    super.key, 
    this.onAddToCart, 
    this.initialCategory = "Semua"
  });

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  late String _selectedCat;

  @override
  void initState() {
    super.initState();
    // Menginisialisasi kategori default berdasarkan kiriman halaman Beranda
    _selectedCat = widget.initialCategory;
  }

  @override
  Widget build(BuildContext context) {
    // LOGIKA FILTER: Menyaring data dummyProducts berbasis ProductModel secara dinamis
    final List<ProductModel> filteredProducts = _selectedCat == "Semua"
        ? dummyProducts
        : dummyProducts.where((p) => p.category == _selectedCat).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          "Semua Produk", 
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Column(
        children: [
          // 1. Search Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Cari produk di IKANKU.ID..",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12), 
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          
          // 2. Category Chips (Horizontal Scroll)
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: ["Semua", "Arwana", "Koki", "Guppy", "Molly", "Peralatan", "Pakan Ikan"].map((cat) {
                final isSelected = _selectedCat == cat;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(cat),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        _selectedCat = cat;
                      });
                    },
                    selectedColor: AppColors.primaryBlue,
                    backgroundColor: Colors.grey[100],
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : Colors.black87,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          // 3. Grid View Layar Produk Terintegrasi
          Expanded(
            child: filteredProducts.isEmpty 
                ? const Center(
                    child: Text(
                      "Produk tidak ditemukan", 
                      style: TextStyle(color: Colors.grey),
                    ),
                  ) 
                : GridView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.72,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    itemCount: filteredProducts.length,
                    itemBuilder: (context, index) {
                      final product = filteredProducts[index];
                      
                      // Cek otomatis apakah kategori produk termasuk ikan hias atau perlengkapan non-ikan
                      final isFish = ["Arwana", "Koki", "Guppy", "Molly"].contains(product.category);

                      return GestureDetector(
                        onTap: () {
                          // Navigasi ke detail produk dengan melempar data berbasis ProductModel objek
                          Navigator.push(
                            context, 
                            MaterialPageRoute(
                              builder: (context) => ProductDetailPage(
                                product: product,
                                onAddToCart: widget.onAddToCart, 
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
                              // Render Gambar Asset Dinamis
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.only(
                                    topLeft: Radius.circular(12), 
                                    topRight: Radius.circular(12),
                                  ),
                                  child: Image.asset(
                                    product.imagePath,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        color: Colors.grey[100], 
                                        child: const Icon(Icons.broken_image, color: Colors.grey),
                                      );
                                    },
                                  ),
                                ),
                              ),
                              // Detail Teks Informasi Produk
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      product.name,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                    ),
                                    const SizedBox(height: 3),
                                    // Deskripsi dinamis adaptif sesuai kategori pakan / ikan
                                    Text(
                                      product.description,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(fontSize: 11, color: Colors.grey),
                                    ),
                                    const SizedBox(height: 4),
                                    // Tag Varian: Hanya merender info Jantan/Betina jika kategori diidentifikasi sebagai Ikan
                                    if (isFish)
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: AppColors.primaryBlue.withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        child: const Text(
                                          "Jantan / Betina / Pasang",
                                          style: TextStyle(fontSize: 9, color: AppColors.primaryBlue, fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    const SizedBox(height: 8),
                                    // Baris Harga dan Aksi Keranjang Belanja
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Rp ${product.price.toStringAsFixed(0)}",
                                          style: const TextStyle(
                                            color: AppColors.primaryBlue, 
                                            fontWeight: FontWeight.bold, 
                                            fontSize: 13,
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            if (widget.onAddToCart != null) {
                                              widget.onAddToCart!(product.name);
                                            }
                                          },
                                          child: const CircleAvatar(
                                            radius: 14,
                                            backgroundColor: AppColors.primaryBlue,
                                            child: Icon(Icons.add_shopping_cart, size: 14, color: Colors.white),
                                          ),
                                        ),
                                      ],
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
          ),
        ],
      ),
    );
  }
}