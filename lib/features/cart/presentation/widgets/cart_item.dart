import 'package:flutter/material.dart';

class CartItem extends StatelessWidget {
  final Map<String, dynamic> item;

  const CartItem({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          // Gambar Produk (Dummy)
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.set_meal, color: Colors.blue, size: 40),
          ),
          const SizedBox(width: 16),
          // Informasi Produk
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['name'] ?? "Produk Ikan",
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const Text(
                  "Varian: Jantan", 
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
                const SizedBox(height: 8),
                Text(
                  item['price'] ?? "Rp0",
                  style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          // Counter Sederhana
          Row(
            children: [
              _buildQtyBtn(Icons.remove_circle_outline),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Text("1", style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              _buildQtyBtn(Icons.add_circle_outline),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQtyBtn(IconData icon) {
    return IconButton(
      onPressed: () {},
      icon: Icon(icon, color: Colors.blue, size: 24),
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(),
    );
  }
}