import 'package:flutter/material.dart';
import '../../../../core/constants/colors.dart';
import '../../data/models/article_model.dart';
import 'article_detail_page.dart';

class ArticlePage extends StatelessWidget {
  const ArticlePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text(
          "Edukasi Perawatan",
          style: TextStyle(color: AppColors.primaryBlue, fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        itemCount: dummyArticles.length,
        itemBuilder: (context, index) {
          final article = dummyArticles[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.grey.shade200),
              borderRadius: BorderRadius.circular(12),
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ArticleDetailPage(article: article),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: article.imagePath.isNotEmpty
                          ? Image.asset(article.imagePath, width: 60, height: 60, fit: BoxFit.cover)
                          : Container(
                              width: 60,
                              height: 60,
                              color: Colors.green[50],
                              child: const Icon(Icons.eco, color: Colors.green),
                            ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            article.title, 
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)
                          ),
                          const SizedBox(height: 4),
                          Text(
                            article.subtitle, 
                            style: const TextStyle(fontSize: 12, color: Colors.grey)
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 14),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}