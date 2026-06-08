// profile_page.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'settings_page.dart';
import '../widgets/profile_menu_item.dart';
import '../widgets/order_status_card.dart';
import 'my_orders_page.dart'; 
import 'edit_profile_page.dart'; 
import 'saved_addresses_page.dart'; // <-- PERUBAHAN: Import halaman alamat yang baru
import 'package:ikanku/features/chat/presentation/pages/message_list_page.dart';
import 'package:ikanku/features/profile/data/models/user_model.dart';
import 'package:ikanku/features/profile/data/datasources/profile_service.dart';
import 'package:ikanku/features/auth/presentation/pages/login_page.dart'; 

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  UserModel? _user;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    final data = await ProfileService.getProfile();
    if (!mounted) return;
    setState(() {
      _user = data;
      _isLoading = false;
    });
  }

  void _goToOrders(BuildContext context, int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MyOrdersPage(initialTab: index),
      ),
    );
  }

  // LOGIKA BARU: Mengambil teks alamat yang ditandai sebagai UTAMA
  String _getMainAddressSubtitle() {
    if (_user == null || _user!.addresses.isEmpty) {
      return "Alamat belum diatur";
    }
    
    // Mencari alamat yang di-set sebagai utama (isMain = true)
    final mainAddress = _user!.addresses.firstWhere(
      (element) => element.isMain,
      orElse: () => _user!.addresses.first, // Jika tidak ada, ambil indeks pertama
    );

    return "${mainAddress.label}: ${mainAddress.detailAddress}";
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Color(0xffF5F7FA),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xffF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Akun saya",
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w600,
          ),
        ),
        automaticallyImplyLeading: false, 
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.black87),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SettingsPage()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            // --- FOTO PROFIL DINAMIS ---
            CircleAvatar(
              radius: 45,
              backgroundColor: Colors.grey[300],
              backgroundImage: _user?.profileImagePath != null && _user!.profileImagePath!.isNotEmpty
                  ? FileImage(File(_user!.profileImagePath!)) as ImageProvider
                  : const NetworkImage('https://i.pravatar.cc/300'),
            ),
            const SizedBox(height: 12),
            
            // --- NAMA & EMAIL DINAMIS ---
            Text(
              (_user?.name != null && _user!.name.isNotEmpty) ? _user!.name : "Azani Sakti SR", 
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              (_user?.email != null && _user!.email.isNotEmpty) ? _user!.email : "azani@gmail.com",
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 20),

            // --- KARTU PESANAN ---
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text(
                        "Pesanan Saya",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: () => _goToOrders(context, 0), 
                        child: const Text("Lihat Semua"),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      OrderStatusCard(
                        icon: Icons.wallet_giftcard,
                        title: "Dikemas",
                        onTap: () => _goToOrders(context, 1), 
                      ),
                      OrderStatusCard(
                        icon: Icons.local_shipping,
                        title: "Dikirim",
                        onTap: () => _goToOrders(context, 2), 
                      ),
                      OrderStatusCard(
                        icon: Icons.check_circle,
                        title: "Selesai",
                        onTap: () => _goToOrders(context, 3), 
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // --- MENU LIST ---
            ProfileMenuItem(
              icon: Icons.favorite_border,
              title: "Disukai",
              subtitle: "12 Items Saved",
              onTap: () {},
            ),
            
            // PERBAIKAN UTAMA: Menu Alamat Pengiriman Dinamis
            ProfileMenuItem(
              icon: Icons.location_on_outlined,
              title: "Alamat Pengiriman",
              subtitle: _getMainAddressSubtitle(), // Menggunakan fungsi pencari alamat utama
              onTap: () async {
                // Berpindah ke halaman manajemen daftar alamat baru
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SavedAddressesPage()),
                );
                // Sinkronisasi data ketika kembali ke halaman utama profil
                if (result == true || result == null) {
                  _loadProfileData(); 
                }
              },
            ),

            ProfileMenuItem(
              icon: Icons.credit_card,
              title: "Metode Pembayaran",
              subtitle: (_user?.paymentMethod != null && _user!.paymentMethod.isNotEmpty)
                  ? _user!.paymentMethod
                  : "Belum diatur",
              onTap: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const EditProfilePage()),
                );
                if (result == true) {
                  _loadProfileData();
                }
              },
            ),
            
            ProfileMenuItem(
              icon: Icons.chat_bubble_outline,
              title: "Pesan",
              subtitle: "Cek pesan terbaru",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MessageListPage()),
                );
              },
            ),
            
            ProfileMenuItem(
              icon: Icons.edit_outlined,
              title: "Ubah Profil",
              subtitle: "Perbarui data diri & foto profil",
              onTap: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const EditProfilePage()),
                );
                if (result == true) {
                  _loadProfileData(); 
                }
              },
            ),
            
            const SizedBox(height: 30),

            // --- TOMBOL KELUAR DENGAN KONFIRMASI ---
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade50,
                  foregroundColor: Colors.red,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text("Keluar Akun"),
                        content: const Text("Apakah Anda yakin ingin keluar dari aplikasi Ikanku?"),
                        actions: [
                          TextButton(
                            child: const Text("Batal"),
                            onPressed: () => Navigator.pop(context),
                          ),
                          TextButton(
                            child: const Text("Keluar"),
                            style: TextButton.styleFrom(foregroundColor: Colors.red),
                            onPressed: () {
                              Navigator.pop(context);
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(builder: (context) => const LoginPage()),
                                (route) => false,
                              );
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
                icon: const Icon(Icons.logout),
                label: const Text("Keluar", style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}