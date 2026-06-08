// Path: lib/features/seller/presentation/pages/seller_edit_profile_page.dart

import 'package:flutter/material.dart';

class SellerEditProfilePage extends StatefulWidget {
  const SellerEditProfilePage({super.key});

  @override
  State<SellerEditProfilePage> createState() => _SellerEditProfilePageState();
}

class _SellerEditProfilePageState extends State<SellerEditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  
  // Controller dengan data awal/default
  final _storeNameController = TextEditingController(text: "Aquatic Premium Jakarta");
  final _usernameController = TextEditingController(text: "@aquatic.premium");
  final _descController = TextEditingController(
    text: "Spesialis ikan hias premium dan aksesoris aquarium terlengkap sejak 2018..."
  );
  final _phoneController = TextEditingController(text: "+62 812-3456-7890");
  final _emailController = TextEditingController(text: "contact@aquaticpremium.com");
  final _addressController = TextEditingController(text: "Jl. Kemang Raya No. 12, Mampang Prapatan...");

  // Ekstensi daftar kategori komoditas komplit SJBI
  final List<String> categories = [
    "Koki", "Guppy", "Molly", "Cupang", "Discus", "Channa", "Koi", "Aquarium Set", "Pakan & Vitamin"
  ];
  String selectedCategory = "Koki";

  @override
  void dispose() {
    _storeNameController.dispose();
    _usernameController.dispose();
    _descController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  // Logika kembali ke market utama dengan konfirmasi popUntil
  void _navigateToMainHome() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Kembali ke Beranda Utama?"),
        content: const Text("Pastikan Anda sudah menyimpan perubahan jika ada data baru yang diedit."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), 
            child: const Text("Batal")
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Tutup dialog
              Navigator.of(context).popUntil((route) => route.isFirst);
            }, 
            child: const Text("Ya, Kembali", style: TextStyle(color: Colors.red))
          ),
        ],
      ),
    );
  }

  // SISTEM PROSES PENYIMPANAN DATA FORM
  void _saveChanges() {
    // 1. Validasi state input text form field
    if (_formKey.currentState!.validate()) {
      
      // 2. Kompilasi payload data terupdate dari state controller
      final Map<String, dynamic> updatedSellerData = {
        "store_name": _storeNameController.text.trim(),
        "username": _usernameController.text.trim(),
        "description": _descController.text.trim(),
        "phone": _phoneController.text.trim(),
        "email": _emailController.text.trim(),
        "main_category": selectedCategory,
        "address": _addressController.text.trim(),
      };

      // TODO: Kirim updatedSellerData ke repositori data lokal (SQLite/SharedPreferences) atau Firebase.
      // print(updatedSellerData); // Debugging log

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Profil Toko '${updatedSellerData['store_name']}' berhasil disimpan!"),
          backgroundColor: Colors.green,
        ),
      );
      
      // Kembali ke halaman sebelumnya dengan membawa feedback data sukses
      Navigator.pop(context, updatedSellerData);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Mohon lengkapi semua data input yang valid"),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Edit Profil Penjual", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        actions: [
          IconButton(
            icon: const Icon(Icons.home_filled, color: Colors.blueGrey),
            tooltip: "Kembali ke Market Utama",
            onPressed: _navigateToMainHome,
          ),
          TextButton(
            onPressed: _saveChanges,
            child: const Text("Simpan", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
          )
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildImageHeader(),
              const SizedBox(height: 24),
              _buildFieldLabel("Nama Toko"),
              _buildTextFormField(
                _storeNameController, 
                validationMessage: "Nama toko tidak boleh kosong"
              ),
              _buildFieldLabel("Username"),
              _buildTextFormField(
                _usernameController, 
                validationMessage: "Username toko tidak boleh kosong"
              ),
              _buildFieldLabel("Deskripsi Toko"),
              _buildTextFormField(_descController, maxLines: 3, validationMessage: "Berikan deskripsi singkat toko Anda"),
              
              const Divider(height: 32),
              const Text("Informasi Kontak", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              const SizedBox(height: 16),
              _buildFieldLabel("Nomor Telepon"),
              _buildTextFormField(_phoneController, keyboardType: TextInputType.phone, validationMessage: "Nomor telepon aktif diperlukan"),
              _buildFieldLabel("Email Toko"),
              _buildTextFormField(_emailController, keyboardType: TextInputType.emailAddress, validationMessage: "Format email tidak valid"),
              
              const Divider(height: 32),
              const Text("Kategori Utama Jualan", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              const SizedBox(height: 12),
              _buildCategoryChips(),
              
              const Divider(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Lokasi Toko", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  TextButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.gps_fixed, size: 16, color: Colors.blue),
                    label: const Text("Gunakan GPS", style: TextStyle(fontSize: 12, color: Colors.blue)),
                  )
                ],
              ),
              const SizedBox(height: 8),
              _buildMapPlaceholder(),
              const SizedBox(height: 12),
              _buildFieldLabel("Alamat Lengkap"),
              _buildTextFormField(_addressController, maxLines: 2, validationMessage: "Alamat fisik toko wajib diisi"),
              const SizedBox(height: 24),
              
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveChanges,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text("Simpan Perubahan", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFieldLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6, top: 12),
      child: Text(label.toUpperCase(), style: const TextStyle(fontSize: 11, color: Colors.grey, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildTextFormField(TextEditingController controller, {int maxLines = 1, TextInputType keyboardType = TextInputType.text, required String validationMessage}) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return validationMessage;
        }
        return null;
      },
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xffF7F9FC),
        contentPadding: const EdgeInsets.all(14),
        errorStyle: const TextStyle(color: Colors.redAccent),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
        focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Colors.redAccent, width: 1)),
        errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Colors.redAccent, width: 1)),
      ),
    );
  }

  Widget _buildImageHeader() {
    return SizedBox(
      height: 160,
      child: Stack(
        clipBehavior: Clip.none, 
        children: [
          Container(
            width: double.infinity,
            height: 120,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(12),
              image: const DecorationImage(
                image: NetworkImage('https://images.unsplash.com/photo-1522069169874-c58ec4b76be5?w=500'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 16,
            child: Stack(
              children: [
                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    color: Colors.blue.shade900,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.white, width: 3),
                  ),
                  child: const Icon(Icons.set_meal, color: Colors.white, size: 35),
                ),
                const Positioned(
                  bottom: 0,
                  right: 0,
                  child: CircleAvatar(
                    radius: 10,
                    backgroundColor: Colors.blue,
                    child: Icon(Icons.edit, size: 10, color: Colors.white),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildCategoryChips() {
    return Wrap(
      spacing: 8,
      runSpacing: 4,
      children: categories.map((cat) {
        final isSelected = selectedCategory == cat;
        return ChoiceChip(
          label: Text(cat),
          selected: isSelected,
          onSelected: (bool selected) {
            setState(() {
              if (selected) selectedCategory = cat;
            });
          },
          selectedColor: Colors.blue.shade50,
          checkmarkColor: Colors.blue,
          labelStyle: TextStyle(
            color: isSelected ? Colors.blue : Colors.black87,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildMapPlaceholder() {
    return Container(
      height: 140,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.blue.shade900,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Center(
        child: Icon(Icons.location_pin, color: Colors.white, size: 40),
      ),
    );
  }
}