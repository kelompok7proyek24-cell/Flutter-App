// lib/features/profile/presentation/pages/payment_method_page.dart

import 'package:flutter/material.dart';

class PaymentMethodPage extends StatefulWidget {
  const PaymentMethodPage({super.key});

  @override
  State<PaymentMethodPage> createState() => _PaymentMethodPageState();
}

class _PaymentMethodPageState extends State<PaymentMethodPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F7FA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Metode Pembayaran",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader("Kartu Kredit & Debit", trailing: "2 KARTU"),
            const SizedBox(height: 12),
            SizedBox(
              height: 170,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _buildCreditCard(
                    colors: [const Color(0xff0099f7), const Color(0xff1ca7ec)],
                    brand: "VISA",
                    cardNumber: "•••• •••• •••• 4292",
                    holder: "DEEP SEA EXPLORER",
                    expiry: "12/26",
                  ),
                  const SizedBox(width: 14),
                  _buildCreditCard(
                    colors: [const Color(0xff2c3e50), const Color(0xff3498db)],
                    brand: "MASTERCARD",
                    cardNumber: "•••• •••• •••• 8812",
                    holder: "DEEP SEA EXPLORER",
                    expiry: "08/28",
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            _buildSectionHeader("Dompet Digital"),
            const SizedBox(height: 12),
            _buildWalletItem(
              icon: Icons.account_balance_wallet,
              iconColor: const Color(0xff00b14f),
              title: "GoPay",
              subtitle: "Terhubung • 0812****9021",
              trailingText: "AKTIF",
              isLinked: true,
            ),
            const SizedBox(height: 12),
            _buildWalletItem(
              icon: Icons.stars_rounded,
              iconColor: const Color(0xff4d178e),
              title: "OVO",
              subtitle: "Belum Terhubung",
              trailingText: "HUBUNGKAN",
              isLinked: false,
            ),
            const SizedBox(height: 24),
            _buildSectionHeader("Transfer Bank (VA)"),
            const SizedBox(height: 12),
            _buildBankItem(
              logoText: "BCA",
              bankName: "Bank Central Asia",
              description: "Virtual Account Konfirmasi Otomatis",
            ),
            const SizedBox(height: 12),
            _buildBankItem(
              logoText: "Mandiri",
              bankName: "Bank Mandiri",
              description: "Pengecekan Manual (10-30 menit)",
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff0099f7),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  elevation: 2,
                ),
                onPressed: () {},
                icon: const Icon(Icons.add_circle_outline, size: 20),
                label: const Text(
                  "Tambah Metode Pembayaran",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, {String? trailing}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        if (trailing != null)
          Text(
            trailing,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xff0099f7)),
          ),
      ],
    );
  }

  Widget _buildCreditCard({
    required List<Color> colors,
    required String brand,
    required String cardNumber,
    required String holder,
    required String expiry,
  }) {
    return Container(
      width: 280,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: colors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: colors[0].withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Icon(Icons.credit_card, color: Colors.white70, size: 26),
              Text(
                brand,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic, fontSize: 16),
              ),
            ],
          ),
          Text(
            cardNumber,
            style: const TextStyle(color: Colors.white, fontSize: 18, letterSpacing: 2, fontWeight: FontWeight.w600),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // SINKRONISASI FIX: Menghapus keyword const di depan Text dan mengganti tipe pemanggilan warna
                  Text("CARD HOLDER", style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 9, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 2),
                  Text(holder, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // SINKRONISASI FIX: Menghapus keyword const di depan Text dan mengganti tipe pemanggilan warna
                  Text("EXPIRES", style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 9, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 2),
                  Text(expiry, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWalletItem({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required String trailingText,
    required bool isLinked,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                const SizedBox(height: 2),
                Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
          ),
          Text(
            trailingText,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: isLinked ? Colors.grey : const Color(0xff0099f7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBankItem({
    required String logoText,
    required String bankName,
    required String description,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          Container(
            width: 55,
            height: 36,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: const Color(0xffF5F7FA),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              logoText,
              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue, fontSize: 13),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(bankName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: 2),
                Text(description, style: const TextStyle(color: Colors.grey, fontSize: 11)),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
        ],
      ),
    );
  }
}