import 'package:flutter/material.dart';
import '../../../../core/constants/colors.dart';
import '../../data/models/article_model.dart';

class ArticleDetailPage extends StatelessWidget {
  final ArticleModel article;

  const ArticleDetailPage({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primaryBlue),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Detail Artikel",
          style: TextStyle(color: AppColors.primaryBlue, fontWeight: FontWeight.bold, fontSize: 16),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gambar Utama Artikel / Icon Placeholder
            Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                color: Colors.green[50],
                borderRadius: BorderRadius.circular(12),
              ),
              child: article.imagePath.isNotEmpty
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(article.imagePath, fit: BoxFit.cover),
                    )
                  : const Icon(Icons.eco, color: Colors.green, size: 64),
            ),
            const SizedBox(height: 20),

            // Judul Artikel
            Text(
              article.title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
            const SizedBox(height: 8),

            // Subtitle / Ringkasan Singkat
            Text(
              article.subtitle,
              style: TextStyle(fontSize: 14, color: Colors.grey[600], fontStyle: FontStyle.italic),
            ),
            const Divider(height: 32, thickness: 1),

            // Konten Isi Artikel
            Text(
              article.content,
              style: const TextStyle(fontSize: 15, height: 1.6, color: Colors.black87),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}