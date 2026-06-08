// edit_profile_page.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ikanku/features/profile/data/models/user_model.dart';
import 'package:ikanku/features/profile/data/datasources/profile_service.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _paymentController = TextEditingController(); // Controller untuk Metode Pembayaran

  String? _imagePath;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCurrentData();
  }

  // Mengisi form field dengan data yang sudah tersimpan di SharedPreferences
  Future<void> _loadCurrentData() async {
    final user = await ProfileService.getProfile();
    _nameController.text = user.name;
    _emailController.text = user.email;
    _phoneController.text = user.phone;
    _addressController.text = user.address;
    _paymentController.text = user.paymentMethod; // Load data metode pembayaran
    setState(() {
      _imagePath = user.profileImagePath;
      _isLoading = false;
    });
  }

  // Fungsi memicu pengambilan gambar dari galeri HP
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    
    if (pickedFile != null) {
      setState(() {
        _imagePath = pickedFile.path;
      });
    }
  }

  // Menyimpan seluruh data perubahan ke database lokal
  Future<void> _saveProfileChanges() async {
    final updatedUser = UserModel(
      name: _nameController.text,
      email: _emailController.text,
      phone: _phoneController.text,
      address: _addressController.text,
      profileImagePath: _imagePath,
      paymentMethod: _paymentController.text, // Simpan data metode pembayaran baru
    );

    await ProfileService.saveProfile(updatedUser);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Profil Berhasil Diperbarui")),
      );
      // Kembali ke Halaman Utama Profil dengan membawa sinyal 'true' untuk auto-refresh
      Navigator.pop(context, true);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _paymentController.dispose(); // Bersihkan memori controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        title: const Text("Edit Profil"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // --- FOTO PROFIL DENGAN FEEDBACK LIVE UPLOAD ---
            GestureDetector(
              onTap: _pickImage,
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 55,
                    backgroundColor: Colors.grey[200],
                    backgroundImage: _imagePath != null
                        ? FileImage(File(_imagePath!)) as ImageProvider
                        : const NetworkImage('https://i.pravatar.cc/300'),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.blue,
                      ),
                      child: const Icon(
                        Icons.camera_alt,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // --- INPUT FIELDS MENGGUNAKAN CONTROLLER ---
            _buildField("Nama Lengkap", "Masukkan nama lengkap", _nameController),
            _buildField("Email", "Masukkan alamat email", _emailController),
            _buildField("Nomor Telepon", "Masukkan nomor telepon", _phoneController),
            _buildField("Alamat Pengiriman", "Alamat lengkap pengiriman", _addressController),
            _buildField("Metode Pembayaran Utama", "Misal: Transfer Bank (VA), Visa ****4242", _paymentController),

            const SizedBox(height: 30),

            // --- BUTTON SIMPAN PERUBAHAN ---
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: _saveProfileChanges,
                child: const Text(
                  "Simpan Perubahan",
                  style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget builder field yang disesuaikan untuk menerima parameter controller
  Widget _buildField(String title, String hint, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title.toUpperCase(),
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: hint,
              filled: true,
              fillColor: const Color(0xffF5F7FA),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}