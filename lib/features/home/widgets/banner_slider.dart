import 'package:flutter/material.dart';
import '../../../../core/constants/colors.dart';

class BannerSlider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 160,
      decoration: BoxDecoration(
        color: AppColors.primaryBlue,
        borderRadius: BorderRadius.circular(15),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Stack(
          children: [
            // Gambar Ikan Bawaan (Placeholder jika asset belum ada)
            Positioned(
              right: -20,
              bottom: -10,
              child: Opacity(
                opacity: 0.3,
                child: Icon(Icons.set_meal, size: 150, color: Colors.white),
              ),
            ),
            Center(
              child: Text(
                "IKANKU.ID",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}