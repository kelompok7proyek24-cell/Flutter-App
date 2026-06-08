// saved_addresses_page.dart

import 'package:flutter/material.dart';
import 'package:ikanku/features/profile/data/models/user_model.dart';
import 'package:ikanku/features/profile/data/datasources/profile_service.dart';
import 'add_address_page.dart';

class SavedAddressesPage extends StatefulWidget {
  const SavedAddressesPage({super.key});

  @override
  State<SavedAddressesPage> createState() => _SavedAddressesPageState();
}

class _SavedAddressesPageState extends State<SavedAddressesPage> {
  UserModel? _currentUser;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAddresses();
  }

  Future<void> _loadAddresses() async {
    final user = await ProfileService.getProfile();
    if (!mounted) return; // Memastikan state widget masih aktif
    setState(() {
      _currentUser = user;
      _isLoading = false;
    });
  }

  Future<void> _setMainAddress(AddressModel selectedAddress) async {
    if (_currentUser == null) return;

    // Mapping ulang status alamat utama
    final updatedList = _currentUser!.addresses.map((addr) {
      return AddressModel(
        id: addr.id,
        label: addr.label,
        receiverName: addr.receiverName,
        phone: addr.phone,
        cityAndSubdistrict: addr.cityAndSubdistrict,
        postalCode: addr.postalCode,
        detailAddress: addr.detailAddress,
        notesForCourier: addr.notesForCourier,
        isMain: addr.id == selectedAddress.id, // Aktifkan hanya untuk id yang dipilih
      );
    }).toList();

    final updatedUser = UserModel(
      name: _currentUser!.name,
      email: _currentUser!.email,
      password: _currentUser!.password,
      phone: _currentUser!.phone,
      profileImagePath: _currentUser!.profileImagePath,
      paymentMethod: _currentUser!.paymentMethod,
      addresses: updatedList,
    );

    await ProfileService.saveProfile(updatedUser);
    _loadAddresses(); // Refresh data tampilan
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF8FAFC),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        title: const Text("Alamat Pengiriman", style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _currentUser!.addresses.isEmpty
              ? _buildEmptyState()
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _currentUser!.addresses.length,
                  itemBuilder: (context, index) {
                    final address = _currentUser!.addresses[index];
                    return _buildAddressCard(address);
                  },
                ),
      bottomNavigationBar: _buildAddButton(),
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Text(
        "Belum ada alamat tersimpan. Silakan tambah alamat baru.",
        style: TextStyle(color: Colors.grey),
      ),
    );
  }

  Widget _buildAddressCard(AddressModel address) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: address.isMain ? Colors.blue : Colors.grey.shade200,
          width: address.isMain ? 2 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                address.label.toLowerCase() == 'rumah'
                    ? Icons.home_outlined
                    : address.label.toLowerCase() == 'kantor'
                        ? Icons.business_outlined
                        : Icons.location_on_outlined,
                color: Colors.blue,
              ),
              const SizedBox(width: 8),
              Text(
                address.label,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(width: 8),
              if (address.isMain)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text(
                    "UTAMA",
                    style: TextStyle(color: Colors.blue, fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Text(address.receiverName, style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.black87)),
          Text(address.phone, style: const TextStyle(color: Colors.grey, fontSize: 13)),
          const SizedBox(height: 6),
          Text(
            "${address.detailAddress}, ${address.cityAndSubdistrict}, ${address.postalCode}",
            style: const TextStyle(color: Colors.black87, fontSize: 13, height: 1.4), // FIXED: Mengubah dari blackDE ke black87
          ),
          if (address.notesForCourier.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text("Catatan: ${address.notesForCourier}",
                style: TextStyle(color: Colors.grey.shade600, fontSize: 12, fontStyle: FontStyle.italic)),
          ],
          const Divider(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (!address.isMain)
                TextButton(
                  onPressed: () => _setMainAddress(address),
                  child: const Text("Jadikan Utama", style: TextStyle(color: Colors.blue)),
                )
              else
                const SizedBox(),
              IconButton(
                icon: const Icon(Icons.edit_outlined, color: Colors.grey),
                onPressed: () {
                  // Fitur edit alamat bisa dikembangkan di sini jika diperlukan
                },
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _buildAddButton() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          minimumSize: const Size(double.infinity, 52),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
        onPressed: () async {
          // Buka Halaman Tambah Alamat, tunggu respons balik berupa sinyal true
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddAddressPage()),
          );
          
          if (!mounted) return; // Pelindung Async Context setelah proses await selesai
          if (result == true) {
            _loadAddresses(); // Refresh otomatis jika berhasil simpan
          }
        },
        child: const Text(
          "Tambah Alamat Baru",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
    );
  }
}