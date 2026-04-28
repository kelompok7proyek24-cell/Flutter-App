import 'package:flutter/material.dart';
import '../../../../core/constants/colors.dart';

class HomeHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Row(
            children: [
              Icon(Icons.settings_outlined, color: AppColors.primaryBlue),
              Expanded(
                child: Center(
                  child: Text(
                    "IKANKU.ID",
                    style: TextStyle(
                      color: AppColors.primaryBlue,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
              _buildCartIcon("2"), // Badge angka 2 sesuai gambar
            ],
          ),
        ),
        // Search Bar
        TextField(
          decoration: InputDecoration(
            hintText: "Cari ikan terbaikmu..",
            prefixIcon: Icon(Icons.search, color: Colors.grey),
            filled: true,
            fillColor: Colors.grey[100],
            contentPadding: EdgeInsets.symmetric(vertical: 0),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCartIcon(String count) {
    return Stack(
      children: [
        Icon(Icons.shopping_cart_outlined, color: AppColors.primaryBlue),
        Positioned(
          right: 0,
          top: 0,
          child: Container(
            padding: EdgeInsets.all(2),
            decoration: BoxDecoration(color: Colors.red, shape: BoxShape.circle),
            constraints: BoxConstraints(minWidth: 12, minHeight: 12),
            child: Text(
              count,
              style: TextStyle(color: Colors.white, fontSize: 8),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }
}