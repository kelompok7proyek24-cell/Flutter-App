import 'package:flutter/material.dart';
import '../../../../core/constants/colors.dart';
import 'package:ikanku/features/seller/data/models/product_model.dart';

class CheckoutPage extends StatefulWidget {
  final List<Map<String, dynamic>> checkoutItems;
  final double totalPrice;

  const CheckoutPage({
    super.key,
    required this.checkoutItems,
    required this.totalPrice,
  });

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  // Data statis untuk simulasi pilihan pengiriman & pembayaran
  final double _shippingFee = 15000;
  String _selectedPayment = "Transfer Bank (VA)";
  String _selectedCourier = "Reguler (J&T Express)";

  @override
  Widget build(BuildContext context) {
    final double finalTotal = widget.totalPrice + _shippingFee;
    final mediaQuery = MediaQuery.of(context);
    final isLandscape = mediaQuery.orientation == Orientation.landscape;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Checkout",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // KONTEN UTAMA (Scrollable & Responsive)
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. SEKSI ALAMAT PENGIRIMAN
                  _buildSectionTitle("Alamat Pengiriman"),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: const Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.location_on, color: AppColors.primaryBlue, size: 22),
                        SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Azani Sakti Sya'Ban Rifa'I (Kontrakan Polindra)",
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                              ),
                              SizedBox(height: 4),
                              Text(
                                "081234567890",
                                style: TextStyle(color: Colors.grey, fontSize: 13),
                              ),
                              SizedBox(height: 4),
                              Text(
                                "Jl. Raya Lohbener Blok Remis, No. 15, Kec. Lohbener, Kabupaten Indramayu, Jawa Barat 45252",
                                style: TextStyle(color: Colors.black87, fontSize: 13, height: 1.4),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // 2. SEKSI RINGKASAN PRODUK YANG DIBELI (Sudah Diperbaiki)
                  _buildSectionTitle("Produk dipesan"),
                  const SizedBox(height: 8),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: widget.checkoutItems.length,
                    itemBuilder: (context, index) {
                      final item = widget.checkoutItems[index];
                      // Melakukan explicit casting untuk menghilangkan error sintaksis
                      final ProductModel product = item['product'] as ProductModel;
                      final int quantity = item['quantity'] as int;

                      return Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.asset(
                                product.imagePath,
                                width: 60,
                                height: 60,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) => Container(
                                  width: 60,
                                  height: 60,
                                  color: Colors.grey[100],
                                  child: const Icon(Icons.broken_image, color: Colors.grey),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    product.name,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "Rp ${product.price.toStringAsFixed(0)}",
                                    style: const TextStyle(color: AppColors.primaryBlue, fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              "x$quantity",
                              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black54),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 12),

                  // 3. OPSI PENGIRIMAN & OPSI PEMBAYARAN
                  _buildDropdownSection(
                    title: "Metode Pengiriman",
                    value: _selectedCourier,
                    items: ["Reguler (J&T Express)", "Kargo (JNE Trucking)", "Instant (Gojek/Grab)"],
                    icon: Icons.local_shipping_outlined,
                    onChanged: (val) => setState(() => _selectedCourier = val!),
                  ),
                  const SizedBox(height: 12),
                  _buildDropdownSection(
                    title: "Metode Pembayaran",
                    value: _selectedPayment,
                    items: ["Transfer Bank (VA)", "E-Wallet (Dana/OVO)", "COD (Bayar di Tempat)"],
                    icon: Icons.account_balance_wallet_outlined,
                    onChanged: (val) => setState(() => _selectedPayment = val!),
                  ),
                  const SizedBox(height: 20),

                  // 4. RINCIAN BIAYA AKHIR
                  _buildSectionTitle("Rincian Pembayaran"),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Column(
                      children: [
                        _buildSummaryRow("Subtotal Produk", widget.totalPrice),
                        const SizedBox(height: 8),
                        _buildSummaryRow("Total Ongkos Kirim", _shippingFee),
                        const Divider(height: 24, thickness: 1),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Total Pembayaran", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                            Text(
                              "Rp ${finalTotal.toStringAsFixed(0)}",
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.redAccent),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // PANEL BUTTON BOTTOM
          Container(
            padding: EdgeInsets.only(
              left: 20, right: 20, top: 16, 
              bottom: isLandscape ? 16 : 24,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5))
              ],
            ),
            child: SafeArea(
              top: false,
              child: SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    _showSuccessDialog(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryBlue,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                  ),
                  child: const Text(
                    "Buat Pesanan",
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  // REUSABLE COMPONENT: Judul Seksi
  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87),
    );
  }

  // REUSABLE COMPONENT: Dropdown Pilihan Kurir & Pembayaran
  Widget _buildDropdownSection({
    required String title,
    required String value,
    required List<String> items,
    required IconData icon,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(title),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              icon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
              items: items.map((String item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Row(
                    children: [
                      Icon(icon, size: 20, color: AppColors.primaryBlue),
                      const SizedBox(width: 10),
                      Text(item, style: const TextStyle(fontSize: 14)),
                    ],
                  ),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }

  // REUSABLE COMPONENT: Baris Rincian Biaya
  Widget _buildSummaryRow(String label, double amount) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 13)),
        Text("Rp ${amount.toStringAsFixed(0)}", style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13)),
      ],
    );
  }

  // INTERAKSI AKHIR: Dialog Sukses Transaksi
  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 16),
              const CircleAvatar(
                radius: 36,
                backgroundColor: Colors.green,
                child: Icon(Icons.check, size: 40, color: Colors.white),
              ),
              const SizedBox(height: 20),
              const Text(
                "Pesanan Berhasil!",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(height: 10),
              const Text(
                "Ikan atau pakan pilihanmu sedang dipersiapkan oleh seller. Silakan cek berkala status pengiriman.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, fontSize: 13, height: 1.4),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 44,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryBlue,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text("Selesai", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}