// Path: lib/features/seller/presentation/pages/seller_registration_page.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
// INTEGRASI SISTEM: Import Model dan Service Data Anda
import 'package:ikanku/features/profile/data/models/user_model.dart';
import 'package:ikanku/features/profile/data/datasources/profile_service.dart';
import 'seller_dashboard_page.dart';

class SellerRegistrationPage extends StatefulWidget {
  const SellerRegistrationPage({super.key});

  @override
  State<SellerRegistrationPage> createState() => _SellerRegistrationPageState();
}

class _SellerRegistrationPageState extends State<SellerRegistrationPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _storeNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  final ImagePicker _picker = ImagePicker();
  File? _ktpImage;
  File? _storeLogo;

  bool _isLoading = false;

  Future<void> _pickKtpImage() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (image != null) {
      setState(() {
        _ktpImage = File(image.path);
      });
    }
  }

  Future<void> _pickStoreLogo() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (image != null) {
      setState(() {
        _storeLogo = File(image.path);
      });
    }
  }

  Future<void> _registerStore() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_ktpImage == null) {
      _showSnackbar("Upload KTP terlebih dahulu");
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // 1. Ambil data profil pembeli yang aktif saat ini dari SharedPreferences
      final UserModel currentProfile = await ProfileService.getProfile();

      // 2. Lakukan kloning data dengan mutasi field baru menggunakan copyWith
      final UserModel updatedProfile = currentProfile.copyWith(
        isSeller: true,
        shopName: _storeNameController.text.trim(),
        shopCity: "Indramayu", // Sementara hardcoded atau gabungkan ke input jika perlu
        shopAddress: _addressController.text.trim(),
      );

      // 3. Simpan perubahan ke dalam Local Database
      await ProfileService.saveProfile(updatedProfile);

      if (!mounted) return;

      _showSnackbar("Seller berhasil didaftarkan");

      // 4. Navigasi bersih (Menghancurkan stack registrasi)
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const SellerDashboardPage(),
        ),
      );

    } catch (e) {
      _showSnackbar("Terjadi kesalahan pendaftaran data");
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  void dispose() {
    _storeNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF7F9FC),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        title: const Text(
          "Verifikasi Seller",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // =========================================
              // KTP CARD
              // =========================================
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: Colors.blue.withOpacity(0.1)),
                ),
                child: Column(
                  children: [
                    Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.08),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.badge_outlined, color: Colors.blue, size: 36),
                    ),
                    const SizedBox(height: 18),
                    const Text(
                      "Verifikasi Identitas (KTP)",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "Unggah foto KTP untuk mempercepat proses verifikasi seller",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                    const SizedBox(height: 20),
                    if (_ktpImage != null)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.file(
                          _ktpImage!,
                          height: 170,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                    if (_ktpImage != null) const SizedBox(height: 18),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _pickKtpImage,
                        icon: const Icon(Icons.camera_alt),
                        label: const Text("Unggah KTP / Identitas"),
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    const Text(
                      "KERAHASIAAN DATA ANDA TERJAMIN",
                      style: TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // =========================================
              // STORE LOGO
              // =========================================
              GestureDetector(
                onTap: _pickStoreLogo,
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 42,
                      backgroundColor: Colors.grey.shade300,
                      backgroundImage: _storeLogo != null ? FileImage(_storeLogo!) : null,
                      child: _storeLogo == null
                          ? const Icon(Icons.store, size: 38, color: Colors.white)
                          : null,
                    ),
                    const SizedBox(height: 10),
                    const Text("Unggah Logo Toko", style: TextStyle(color: Colors.grey, fontSize: 12)),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // =========================================
              // INFO SECTION
              // =========================================
              _buildSectionTitle(Icons.check_circle_outline, "Informasi Seller"),
              const SizedBox(height: 18),
              _buildTextField(
                label: "Nama Toko",
                hint: "Masukkan nama toko",
                controller: _storeNameController,
                validator: (value) {
                  if (value == null || value.isEmpty) return "Nama toko wajib diisi";
                  return null;
                },
              ),
              _buildTextField(
                label: "Email Toko",
                hint: "contact@store.com",
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) return "Email wajib diisi";
                  if (!value.contains("@")) return "Format email tidak valid";
                  return null;
                },
              ),
              _buildTextField(
                label: "Nomor Telepon",
                hint: "+62 812...",
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) return "Nomor telepon wajib diisi";
                  return null;
                },
              ),

              const SizedBox(height: 24),

              // =========================================
              // LOCATION SECTION
              // =========================================
              _buildSectionTitle(Icons.location_on_outlined, "Lokasi & Deskripsi"),
              const SizedBox(height: 18),
              _buildTextField(
                label: "Alamat Toko",
                hint: "Jl. Kemang Raya No.12",
                controller: _addressController,
                maxLines: 2,
                validator: (value) {
                  if (value == null || value.isEmpty) return "Alamat wajib diisi";
                  return null;
                },
              ),
              _buildTextField(
                label: "Deskripsi Toko",
                hint: "Jelaskan toko dan jenis ikan anda",
                controller: _descriptionController,
                maxLines: 4,
                validator: (value) {
                  if (value == null || value.isEmpty) return "Deskripsi wajib diisi";
                  return null;
                },
              ),

              const SizedBox(height: 30),

              // =========================================
              // BUTTON REGISTER
              // =========================================
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _registerStore,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                        )
                      : const Text("Register Store", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(IconData icon, String title) {
    return Row(
      children: [
        Icon(icon, color: Colors.blue),
        const SizedBox(width: 10),
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
      ],
    );
  }

  Widget _buildTextField({
    required String label,
    required String hint,
    required TextEditingController controller,
    required String? Function(String?) validator,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label.toUpperCase(), style: const TextStyle(fontSize: 11, color: Colors.grey, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            maxLines: maxLines,
            validator: validator,
            decoration: InputDecoration(
              hintText: hint,
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.all(16),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
              errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: Colors.red)),
            ),
          ),
        ],
      ),
    );
  }
}