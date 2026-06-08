import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/constants/colors.dart';
// IMPORT SELLER MODEL: Membawa data dummy terpusat (termasuk path gambar produk)
import '../../../seller/data/models/product_model.dart';
import 'package:ikanku/features/checkout/presentation/checkout_page.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  // Map untuk menyimpan ID produk dan jumlah kuantitas yang dibeli
  Map<String, int> _cartItems = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCartData();
  }

  // MEMBACA DATA DARI PENYIMPANAN LOKAL
  Future<void> _loadCartData() async {
    final prefs = await SharedPreferences.getInstance();
    Map<String, int> tempCart = {};

    // Ambil data quantity untuk masing-masing produk berdasarkan id
    for (var product in dummyProducts) {
      int quantity = prefs.getInt('cart_qty_${product.id}') ?? 0;
      if (quantity > 0) {
        tempCart[product.id] = quantity;
      }
    }

    // =========================================================================
    // PERBAIKAN: Blok Fallback Initial dihapus agar keranjang bisa kosong murni
    // =========================================================================

    setState(() {
      _cartItems = tempCart;
      _isLoading = false;
    });
  }

  // FUNGSI AKSI: Tambah (+1) atau Kurang (-1) kuantitas item
  Future<void> _updateQuantity(String productId, int delta) async {
    final prefs = await SharedPreferences.getInstance();
    int currentQty = _cartItems[productId] ?? 0;
    int updatedQty = currentQty + delta;

    if (updatedQty <= 0) {
      _cartItems.remove(productId);
      await prefs.remove('cart_qty_$productId');
    } else {
      _cartItems[productId] = updatedQty;
      await prefs.setInt('cart_qty_$productId', updatedQty);
    }

    _syncGlobalCartCount(_cartItems);
    setState(() {});
  }

  // Menyelaraskan total badge angka keranjang di menu utama (home_page)
  Future<void> _syncGlobalCartCount(Map<String, int> cart) async {
    final prefs = await SharedPreferences.getInstance();
    int totalItems = cart.values.fold(0, (sum, item) => sum + item);
    await prefs.setInt('cart_count', totalItems);
  }

  // HITUNG OTOMATIS: Kalkulasi jumlah harga berdasarkan state kuantitas terbaru
  double _calculateTotalPrice() {
    double total = 0;
    _cartItems.forEach((productId, quantity) {
      final product = dummyProducts.firstWhere((prod) => prod.id == productId);
      total += product.price * quantity;
    });
    return total;
  }

  // HITUNG TOTAL ITEM
  int _calculateTotalItems() {
    return _cartItems.values.fold(0, (sum, item) => sum + item);
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isLandscape = mediaQuery.orientation == Orientation.landscape;

    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(child: CircularProgressIndicator(color: AppColors.primaryBlue)),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Keranjang Belanja",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: _cartItems.isEmpty
          ? _buildEmptyState()
          : Column(
              children: [
                // LIST ITEM BELANJAAN (RESPONSIF)
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    itemCount: _cartItems.length,
                    itemBuilder: (context, index) {
                      String productId = _cartItems.keys.elementAt(index);
                      int quantity = _cartItems[productId]!;
                      
                      // Mengikat komponen UI dengan kebenaran data model terpusat
                      final product = dummyProducts.firstWhere((prod) => prod.id == productId);

                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.grey.shade100),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            children: [
                              // KOMPONEN GAMBAR: Diambil langsung dari data path objek produk
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.asset(
                                  product.imagePath,
                                  width: 70,
                                  height: 70,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      width: 70,
                                      height: 70,
                                      color: Colors.grey[100],
                                      child: const Icon(Icons.broken_image, color: Colors.grey),
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(width: 12),

                              // INFORMASI NAMA DAN HARGA
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      product.name,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black87),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      "Rp ${product.price.toStringAsFixed(0)}",
                                      style: const TextStyle(color: AppColors.primaryBlue, fontWeight: FontWeight.bold, fontSize: 13),
                                    ),
                                  ],
                                ),
                              ),

                              // PENGATUR JUMLAH BARANG (SISTEM COUNTER)
                              Row(
                                children: [
                                  IconButton(
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
                                    icon: const Icon(Icons.remove_circle_outline, color: Colors.grey, size: 22),
                                    onPressed: () => _updateQuantity(productId, -1),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 12),
                                    child: Text(
                                      "$quantity",
                                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                    ),
                                  ),
                                  IconButton(
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
                                    icon: const Icon(Icons.add_circle_outline, color: AppColors.primaryBlue, size: 22),
                                    onPressed: () => _updateQuantity(productId, 1),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // RINGKASAN PEMBAYARAN DAN TOMBOL CHECKOUT
                Container(
                  padding: EdgeInsets.only(
                    left: 20,
                    right: 20,
                    top: 16,
                    bottom: isLandscape ? 16 : 24, // Proteksi layout viewport landscape
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, -5),
                      )
                    ],
                  ),
                  child: SafeArea(
                    top: false,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Total (${_calculateTotalItems()} Item)",
                              style: const TextStyle(fontSize: 14, color: Colors.black54),
                            ),
                            Text(
                              "Rp ${_calculateTotalPrice().toStringAsFixed(0)}",
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primaryBlue),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            List<Map<String, dynamic>> orderItems = [];
                            
                            _cartItems.forEach((productId, quantity) {
                              final product = dummyProducts.firstWhere((prod) => prod.id == productId);
                              orderItems.add({
                                'product': product,   // Objek ProductModel utuh dari modul seller
                                'quantity': quantity, // Kuantitas belanja saat ini
                              });
                            });

                            if (orderItems.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Keranjang kosong, pilih produk terlebih dahulu."),
                                  backgroundColor: Colors.redAccent,
                                ),
                              );
                              return;
                            }

                            // Berpindah ke Halaman Checkout dengan membawa muatan data item & total harga
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CheckoutPage(
                                  checkoutItems: orderItems,
                                  totalPrice: _calculateTotalPrice(),
                                ),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryBlue,
                            minimumSize: const Size(double.infinity, 48),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            elevation: 0,
                          ),
                          child: const Text(
                            "Lanjutkan Ke Checkout",
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_cart_outlined, size: 64, color: Colors.grey[300]),
          const SizedBox(height: 12),
          const Text(
            "Belum ada produk di keranjang",
            style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}