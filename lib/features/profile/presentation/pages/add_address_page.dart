// add_address_page.dart

import 'package:flutter/material.dart';
import 'package:ikanku/features/profile/data/models/user_model.dart';
import 'package:ikanku/features/profile/data/datasources/profile_service.dart';

class AddAddressPage extends StatefulWidget {
  const AddAddressPage({super.key});

  @override
  State<AddAddressPage> createState() => _AddAddressPageState();
}

class _AddAddressPageState extends State<AddAddressPage> {
  final _formKey = GlobalKey<FormState>();
  
  String _selectedLabel = "Rumah"; // Default pilihan chip label
  final _receiverController = TextEditingController();
  final _phoneController = TextEditingController();
  final _cityController = TextEditingController();
  final _postalController = TextEditingController();
  final _detailController = TextEditingController();
  final _notesController = TextEditingController();
  bool _isMainAddress = false;

  Future<void> _saveNewAddress() async {
    if (_formKey.currentState!.validate()) {
      final currentProfile = await ProfileService.getProfile();

      // Membuat ID Unik berbasis timestamp milidetik
      final newAddress = AddressModel(
        id: "addr-${DateTime.now().millisecondsSinceEpoch}",
        label: _selectedLabel,
        receiverName: _receiverController.text.trim(),
        phone: _phoneController.text.trim(),
        cityAndSubdistrict: _cityController.text.trim(),
        postalCode: _postalController.text.trim(),
        detailAddress: _detailController.text.trim(),
        notesForCourier: _notesController.text.trim(),
        isMain: currentProfile.addresses.isEmpty ? true : _isMainAddress, // Jika alamat pertama, otomatis set Utama
      );

      // Jika alamat baru diatur sebagai utama, matikan status utama alamat lama
      List<AddressModel> updatedList = currentProfile.addresses.map((addr) {
        return AddressModel(
          id: addr.id,
          label: addr.label,
          receiverName: addr.receiverName,
          phone: addr.phone,
          cityAndSubdistrict: addr.cityAndSubdistrict,
          postalCode: addr.postalCode,
          detailAddress: addr.detailAddress,
          notesForCourier: addr.notesForCourier,
          isMain: _isMainAddress ? false : addr.isMain,
        );
      }).toList();

      // Masukkan alamat baru ke dalam daftar list
      updatedList.add(newAddress);

      final updatedUser = UserModel(
        name: currentProfile.name,
        email: currentProfile.email,
        password: currentProfile.password,
        phone: currentProfile.phone,
        profileImagePath: currentProfile.profileImagePath,
        paymentMethod: currentProfile.paymentMethod,
        addresses: updatedList,
      );

      await ProfileService.saveProfile(updatedUser);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Alamat Baru Berhasil Ditambahkan")),
        );
        Navigator.pop(context, true); // Pulang ke halaman daftar dengan sinyal sukses
      }
    }
  }

  @override
  void dispose() {
    _receiverController.dispose();
    _phoneController.dispose();
    _cityController.dispose();
    _postalController.dispose();
    _detailController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        title: const Text("Tambah Alamat Baru", style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- MAP SIMULATION PLACEHOLDER ---
              Container(
                height: 140,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(16),
                  image: const DecorationImage(
                    image: NetworkImage("https://placeholder.com/map_placeholder.png"), // Bisa diganti aset gambar peta lokal Anda
                    fit: BoxFit.cover,
                  ),
                ),
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    color: Colors.white.withOpacity(0.9),
                    child: const Text("📍 Simulasi Lokasi: Lohbener, Indramayu", style: TextStyle(fontSize: 12)),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // --- SELEKSI LABEL ALAMAT ---
              const Text("PILIH LABEL ALAMAT", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey)),
              const SizedBox(height: 8),
              Row(
                children: ["Rumah", "Kantor", "Apartemen"].map((label) {
                  final isSelected = _selectedLabel == label;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: ChoiceChip(
                      label: Text(label),
                      selected: isSelected,
                      selectedColor: Colors.blue,
                      labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.black87),
                      onSelected: (bool selected) {
                        if (selected) setState(() => _selectedLabel = label);
                      },
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),

              // --- FIELD FORM INPUT ---
              _buildInputLabel("NAMA PENERIMA"),
              TextFormField(
                controller: _receiverController,
                validator: (val) => val!.isEmpty ? "Nama penerima wajib diisi" : null,
                decoration: _inputDecoration("Contoh: Budi Santoso"),
              ),
              const SizedBox(height: 16),

              _buildInputLabel("NOMOR TELEPON"),
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                validator: (val) => val!.isEmpty ? "Nomor telepon wajib diisi" : null,
                decoration: _inputDecoration("+62 812-3456-7890"),
              ),
              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildInputLabel("KOTA / KECAMATAN"),
                        TextFormField(
                          controller: _cityController,
                          validator: (val) => val!.isEmpty ? "Wajib diisi" : null,
                          decoration: _inputDecoration("Cari kota atau kecamatan"),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildInputLabel("KODE POS"),
                        TextFormField(
                          controller: _postalController,
                          keyboardType: TextInputType.number,
                          validator: (val) => val!.isEmpty ? "Wajib" : null,
                          decoration: _inputDecoration("10210"),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              _buildInputLabel("DETAIL ALAMAT"),
              TextFormField(
                controller: _detailController,
                maxLines: 3,
                validator: (val) => val!.isEmpty ? "Detail alamat/jalan mohon dilengkapi" : null,
                decoration: _inputDecoration("Nama Jalan, Blok, No. Rumah, atau Patokan"),
              ),
              const SizedBox(height: 16),

              _buildInputLabel("CATATAN UNTUK KURIR (OPSIONAL)"),
              TextFormField(
                controller: _notesController,
                decoration: _inputDecoration("Warna pagar, instruksi titip di security"),
              ),
              const SizedBox(height: 16),

              // --- SWITCH UTAMA ---
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Atur sebagai Alamat Utama", style: TextStyle(fontWeight: FontWeight.w500)),
                  Switch(
                    value: _isMainAddress,
                    activeColor: Colors.blue,
                    onChanged: (val) => setState(() => _isMainAddress = val),
                  ),
                ],
              ),
              const SizedBox(height: 30),

              // --- TOMBOL AKSI SIMPAN ---
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  onPressed: _saveNewAddress,
                  child: const Text("Simpan Alamat", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(text, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey)),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.black26, fontSize: 14),
      filled: true,
      fillColor: const Color(0xffF5F7FA),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
    );
  }
}