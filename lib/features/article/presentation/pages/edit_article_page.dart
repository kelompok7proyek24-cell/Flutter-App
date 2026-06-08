import 'package:flutter/material.dart';
import '../../../../core/constants/colors.dart';
import '../../data/models/article_model.dart';

class EditArticlePage extends StatefulWidget {
  final ArticleModel article;

  const EditArticlePage({super.key, required this.article});

  @override
  State<EditArticlePage> createState() => _EditArticlePageState();
}

class _EditArticlePageState extends State<EditArticlePage> {
  late TextEditingController _titleController;
  late TextEditingController _subtitleController;
  late TextEditingController _contentController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    // Mengisi form input dengan data artikel awal yang dioper
    _titleController = TextEditingController(text: widget.article.title);
    _subtitleController = TextEditingController(text: widget.article.subtitle);
    _contentController = TextEditingController(text: widget.article.content);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _subtitleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _saveChanges() {
    if (_formKey.currentState!.validate()) {
      // Membuat objek data baru dengan perubahan terbaru
      final updatedArticle = ArticleModel(
        id: widget.article.id,
        title: _titleController.text,
        subtitle: _subtitleController.text,
        content: _contentController.text,
        imagePath: widget.article.imagePath,
      );

      // Kembalikan objek data baru ke halaman sebelumnya
      Navigator.pop(context, updatedArticle);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: AppColors.primaryBlue),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Edit Data Artikel",
          style: TextStyle(color: AppColors.primaryBlue, fontWeight: FontWeight.bold, fontSize: 16),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.check, color: AppColors.primaryBlue),
            onPressed: _saveChanges,
          )
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Field Judul
              const Text("Judul Artikel", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              const SizedBox(height: 8),
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  hintText: "Masukkan judul...",
                  filled: true,
                  fillColor: Colors.grey[50],
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                ),
                validator: (value) => value == null || value.isEmpty ? "Judul tidak boleh kosong" : null,
              ),
              const SizedBox(height: 16),

              // Field Subtitle
              const Text("Subtitle / Ringkasan", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              const SizedBox(height: 8),
              TextFormField(
                controller: _subtitleController,
                decoration: InputDecoration(
                  hintText: "Masukkan ringkasan singkat...",
                  filled: true,
                  fillColor: Colors.grey[50],
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                ),
                validator: (value) => value == null || value.isEmpty ? "Subtitle tidak boleh kosong" : null,
              ),
              const SizedBox(height: 16),

              // Field Isi Konten
              const Text("Konten Utama Artikel", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              const SizedBox(height: 8),
              TextFormField(
                controller: _contentController,
                maxLines: 12,
                decoration: InputDecoration(
                  hintText: "Tulis isi edukasi lengkap di sini...",
                  filled: true,
                  fillColor: Colors.grey[50],
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                ),
                validator: (value) => value == null || value.isEmpty ? "Konten tidak boleh kosong" : null,
              ),
              const SizedBox(height: 24),

              // Tombol Simpan
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: _saveChanges,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryBlue,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text("Simpan Perubahan", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}