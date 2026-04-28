import 'package:flutter/material.dart';
import '../../../../core/constants/colors.dart';

class FishCard extends StatelessWidget {
  final String name;
  final String price;
  final String rating;

  FishCard({required this.name, required this.price, required this.rating});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      margin: EdgeInsets.only(right: 16, top: 10, bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Gambar Ikan (Gunakan Container warna sebagai placeholder jika asset belum ada)
          Container(
            height: 100,
            decoration: BoxDecoration(
              color: Colors.orange[100],
              borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
            ),
            child: Center(child: Icon(Icons.set_meal, size: 50, color: Colors.orange)),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("GOLDFISH", style: TextStyle(color: Colors.blue, fontSize: 10, fontWeight: FontWeight.bold)),
                Text(name, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600), maxLines: 1, overflow: TextOverflow.ellipsis),
                Row(
                  children: [
                    Icon(Icons.star, color: Colors.orange, size: 14),
                    Text(rating, style: TextStyle(fontSize: 12)),
                  ],
                ),
                SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(price, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
                    CircleAvatar(
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