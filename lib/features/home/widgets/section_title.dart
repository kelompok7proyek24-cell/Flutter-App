import 'package:flutter/material.dart';
import '../../../../core/constants/colors.dart';

class SectionTitle extends StatelessWidget {
  final String title;
  final VoidCallback? onTap;

  const SectionTitle({super.key, required this.title, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        GestureDetector(
          onTap: onTap,
          child: Text(
            "Lebih banyak",
            style: TextStyle(color: AppColors.primaryBlue, fontSize: 12),
          ),
        ),
      ],
    );
  }
}