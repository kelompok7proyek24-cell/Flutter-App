// Path: lib/features/cart/presentation/pages/cart_page.dart

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/constants/colors.dart';
import '../../data/models/cart_item_model.dart';
// IMPORT SELLER MODEL: Membawa data dummy terpusat asli milikmu
import '../../../seller/data/models/product_model.dart';
import 'package:ikanku/features/checkout/presentation/checkout_page.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  // Menggunakan list objek model terstruktur dari data/models/
  List<CartItemModel> _cartItems = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCartData();
  }

  // MEMBACA DATA DARI PENYIMPANAN LOKAL BERBASIS MULTI-VARIAN (INTEGRASI LOGIKA LAMA)
  Future<void> _loadCartData() async {
    final prefs = await SharedPreferences.getInstance();
    List<CartItemModel> tempCartList = [];
    final keys = prefs.getKeys();

    for (String key in keys) {
      if (key.startsWith('cart_qty_')) {
        int quantity = prefs.getInt(key) ?? 0;
        if (quantity > 0) {
          String cartItemId = key.replaceFirst('cart_qty_', ''); // Contoh: "P001_#_Jantan"
          
          // Memecah kembali ID produk asli dan informasi variannya
          List<String> parts = cartItemId.split('_#_');
          String productId = parts[0];
          String variantName = parts.length > 1 ? parts[1] : "Normal";

          try {
            // Mencari kesocokan data produk di data master seller
            final product = dummyProducts.firstWhere((prod) => prod.id == productId);
            
            // Bungkus data ke dalam CartItemModel
            tempCartList.add(
              CartItemModel(
                id: cartItemId, // Menyimpan composite key untuk keperluan update pref
                name: product.name,
                variant: variantName,
                price: product.price.toInt(), // Konversi ke int sesuai blueprint model barumu
                imagePath: product.imagePath,
                shopName: "Aqua Grace", // Sementara di-hardcode sebelum model master produk mendukung field toko
                quantity: quantity,
                isChecked: true,
              ),
            );
          } catch (e) {
            // Menghindari crash jika id produk di local storage tidak ditemukan di dummy master
            debugPrint("Produk dengan ID $productId tidak ditemukan.");
          }
        }
      }
    }

    setState(() {
      _cartItems = tempCartList;
      _isLoading = false;
    });
  }

  // FUNGSI AKSI GABUNGAN: Update UI sekaligus sinkronisasi ke SharedPreferences lokal
  Future<void> _updateQuantity(int index, int delta) async {
    final prefs = await SharedPreferences.getInstance();
    final item = _cartItems[index];
    int updatedQty = item.quantity + delta;

    setState(() {
      if (updatedQty <= 0) {
        prefs.remove('cart_qty_${item.id}');
        _cartItems.removeAt(index);
      } else {
        item.quantity = updatedQty;
        prefs.setInt('cart_qty_${item.id}', updatedQty);
      }
    });

    _syncGlobalCartCount();
  }

  // Menyelaraskan total badge angka keranjang di menu utama
  Future<void> _syncGlobalCartCount() async {
    final prefs = await SharedPreferences.getInstance();
    int totalItems = _cartItems.fold(0, (sum, item) => sum + item.quantity);
    await prefs.setInt('cart_count', totalItems);
  }

  // KALKULASI OTOMATIS BERBASIS DATA MODEL TERFILTER
  int get _totalPrice {
    return _cartItems
        .where((item) => item.isChecked)
        .fold(0, (sum, item) => sum + (item.price * item.quantity));
  }

  int _calculateTotalItems() {
    return _cartItems.where((item) => item.isChecked).fold(0, (sum, item) => sum + item.quantity);
  }

  void _prosesCheckout() {
    final selectedItems = _cartItems.where((item) => item.isChecked).toList();

    if (selectedItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Keranjang kosong, pilih produk terlebih dahulu."),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    // MEMBANGUN PAYLOAD MAP SESUAI DENGAN KEBUTUHAN ASLI CHECKOUT_PAGE
    List<Map<String, dynamic>> orderItems = selectedItems.map((item) {
      List<String> parts = item.id.split('_#_');
      String productId = parts[0];
      final product = dummyProducts.firstWhere((prod) => prod.id == productId);

      return {
        'product': product,
        'quantity': item.quantity,
        'variant': item.variant,
      };
    }).toList();

    // Pindah ke halaman checkout bawaan proyekmu secara presisi
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CheckoutPage(
          checkoutItems: orderItems,
          totalPrice: _totalPrice.toDouble(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(child: CircularProgressIndicator(color: AppColors.primaryBlue)),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xffF5F7FA),
      appBar: AppBar(
        title: const Text(
          "Keranjang Belanja",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _cartItems.isEmpty ? _buildEmptyCart() : _buildCartList(),
      bottomNavigationBar: _cartItems.isEmpty ? null : _buildBottomBar(),
    );
  }

  Widget _buildEmptyCart() {
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

  Widget _buildCartList() {
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: _cartItems.length,
      itemBuilder: (context, index) {
        final item = _cartItems[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade100),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Checkbox seleksi item keranjang
              Checkbox(
                value: item.isChecked,
                activeColor: AppColors.primaryBlue,
                onChanged: (val) {
                  setState(() {
                    item.isChecked = val ?? true;
                  });
                },
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  item.imagePath,
                  width: 70,
                  height: 70,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    width: 70,
                    height: 70,
                    color: Colors.blue[50],
                    child: const Icon(Icons.broken_image, color: Colors.grey),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.variant == "Normal" ? item.name : "${item.name} (${item.variant})",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Rp ${item.price}",
                      style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryBlue, fontSize: 13),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.remove_circle_outline, color: Colors.grey.shade400),
                    onPressed: () => _updateQuantity(index, -1),
                  ),
                  Text("${item.quantity}", style: const TextStyle(fontWeight: FontWeight.bold)),
                  IconButton(
                    icon: const Icon(Icons.add_circle_outline, color: AppColors.primaryBlue),
                    onPressed: () => _updateQuantity(index, 1),
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xffEEEEEE))),
      ),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Total (${_calculateTotalItems()} Item)", style: const TextStyle(color: Colors.grey, fontSize: 12)),
                const SizedBox(height: 4),
                Text(
                  "Rp $_totalPrice",
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.primaryBlue),
                ),
              ],
            ),
            ElevatedButton(
              onPressed: _prosesCheckout,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryBlue,
                padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                elevation: 0,
              ),
              child: const Text("Lanjutkan Ke Checkout", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            )
          ],
        ),
      ),
    );
  }
}