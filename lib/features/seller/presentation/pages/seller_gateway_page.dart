// seller_gateway_page.dart

import 'package:flutter/material.dart';
import 'package:ikanku/features/profile/data/datasources/profile_service.dart';
import 'package:ikanku/features/seller/presentation/pages/seller_registration_page.dart'; // Halaman Form Daftar Toko
import 'package:ikanku/features/seller/presentation/pages/seller_dashboard_page.dart'; // Halaman Dashboard Toko Utama

class SellerGatewayPage extends StatefulWidget {
  const SellerGatewayPage({super.key});

  @override
  State<SellerGatewayPage> createState() => _SellerGatewayPageState();
}

class _SellerGatewayPageState extends State<SellerGatewayPage> {
  bool _isChecking = true;
  bool _hasShop = false;

  @override
  void initState() {
    super.initState();
    _checkSellerStatus();
  }

  Future<void> _checkSellerStatus() async {
    final user = await ProfileService.getProfile();
    if (!mounted) return;
    
    setState(() {
      _hasShop = user.isSeller;
      _isChecking = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Tampilkan Loading Indicator saat sistem memeriksa SharedPreferences
    if (_isChecking) {
      return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    // Eksekusi Logika Percabangan
    if (_hasShop) {
      return const SellerDashboardPage();
    } else {
      return const SellerRegistrationPage();
    }
  }
}