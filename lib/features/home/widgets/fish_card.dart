import 'package:flutter/material.dart';
import '../../../../core/constants/colors.dart';

class FishCard extends StatelessWidget {
  final String name;
  final String price;
  final String rating;

  // Tambahkan 'const' dan 'super.key' agar sinkron dengan HomePage
  const FishCard({
    super.key, 
    required this.name, 
    required this.price, 
    required this.rating,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: 16, top: 10, bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12, 
            blurRadius: 4, 
            offset: Offset(0, 2),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Gambar Ikan Placeholder
          Container(
            height: 100,
            decoration: BoxDecoration(
              color: Colors.orange[100],
              borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
            ),
            child: const Center(
              child: Icon(Icons.set_meal, size: 50, color: Colors.orange),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "GOLDFISH", 
                  style: TextStyle(
                    color: Colors.blue, 
                    fontSize: 10, 
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  name, 
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600), 
                  maxLines: 1, 
                  overflow: TextOverflow.ellipsis,
                ),
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.orange, size: 14),
                    const SizedBox(width: 4),
                    Text(rating, style: const TextStyle(fontSize: 12)),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      price, 
                      style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                    ),
                    const CircleAvatar(
                      radius: 12,
                      backgroundColor: AppColors.primaryBlue,
                      child: Icon(Icons.add, color: Colors.white, size: 16),
                    )
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}