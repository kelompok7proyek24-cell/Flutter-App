import 'package:flutter/material.dart';
import '../../data/models/product_model.dart';
import 'package:ikanku/features/seller/widgets/inventory_item_tile.dart';
import 'package:ikanku/features/seller/widgets/revenue_card.dart';

class SellerAllInventoryPage extends StatelessWidget {
  const SellerAllInventoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF7F9FC),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        title: const Text(
          "Semua Produk Toko",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: dummyProducts.length, // Menampilkan seluruh data dummy ikan hias
        itemBuilder: (context, index) {
          final product = dummyProducts[index];
          return InventoryItemTile(
            productName: product.name,
            price: "Rp ${product.price.toStringAsFixed(0)}",
            stockText: product.status == "danger" 
                ? "Low: ${product.stock} units" 
                : "${product.stock} in stock",
            imagePath: product.imagePath,
            status: product.status,
          );
        },
      ),
    );
  }
}