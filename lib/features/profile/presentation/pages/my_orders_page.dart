import 'package:flutter/material.dart';

class MyOrdersPage extends StatelessWidget {
  final int initialTab; // Menerima lemparan index dari ProfilePage

  const MyOrdersPage({super.key, this.initialTab = 0});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      initialIndex: initialTab,
      child: Scaffold(
        backgroundColor: const Color(0xffF5F7FA),
        appBar: AppBar(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0.5,
          centerTitle: true,
          title: const Text(
            "Pesanan Saya",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          bottom: const TabBar(
            isScrollable: true,
            indicatorColor: Colors.blue,
            labelColor: Colors.blue,
            unselectedLabelColor: Colors.grey,
            labelStyle: TextStyle(fontWeight: FontWeight.bold),
            tabs: [
              Tab(text: "Semua"),
              Tab(text: "Dikemas"),
              Tab(text: "Dikirim"),
              Tab(text: "Selesai"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildOrderList(context, "Semua"),
            _buildOrderList(context, "Dikemas"),
            _buildOrderList(context, "Dikirim"),
            _buildOrderList(context, "Selesai"),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderList(BuildContext context, String filterStatus) {
    // Data Dummy Pesanan sesuai desain Gambar 3
    final List<Map<String, dynamic>> dummyOrders = [
      {
        "shop": "AquaGrace",
        "status": "Dikirim",
        "product": "Koki Oranda",
        "desc": "Sepasang",
        "price": "Rp45.000",
        "total": "Rp60.000",
        "date": "1 Apr Diterima"
      },
      {
        "shop": "AquaGrace",
        "status": "Dikemas",
        "product": "Red Ryukin",
        "desc": "Satuan",
        "price": "Rp25.000",
        "total": "Rp35.000",
        "date": "Perkiraan: 7 Apr"
      },
    ];

    // Logika Filter Sederhana
    final filteredOrders = filterStatus == "Semua" 
        ? dummyOrders 
        : dummyOrders.where((o) => o['status'] == filterStatus).toList();

    if (filteredOrders.isEmpty) {
      return const Center(child: Text("Belum ada pesanan"));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: filteredOrders.length,
      itemBuilder: (context, index) {
        final order = filteredOrders[index];
        return _buildOrderCard(order);
      },
    );
  }

  Widget _buildOrderCard(Map<String, dynamic> order) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Kartu: Toko & Status
          Row(
            children: [
              const Icon(Icons.store, size: 18, color: Colors.blue),
              const SizedBox(width: 8),
              Text(order['shop'], style: const TextStyle(fontWeight: FontWeight.bold)),
              const Spacer(),
              Text(order['status'], style: const TextStyle(color: Colors.blue, fontSize: 12)),
            ],
          ),
          const Divider(height: 24),
          
          // Info Pengiriman
          Row(
            children: [
              const Icon(Icons.local_shipping_outlined, size: 16, color: Colors.grey),
              const SizedBox(width: 8),
              Expanded(
                child: Text(order['date'], style: const TextStyle(fontSize: 12, color: Colors.grey)),
              ),
              const Icon(Icons.chevron_right, size: 16, color: Colors.grey),
            ],
          ),
          const SizedBox(height: 16),

          // Detail Produk
          Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.set_meal, color: Colors.blue),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(order['product'], style: const TextStyle(fontWeight: FontWeight.bold)),
                    Text(order['desc'], style: const TextStyle(fontSize: 12, color: Colors.grey)),
                    const Text("x1", style: TextStyle(fontSize: 12)),
                  ],
                ),
              ),
              Text(order['price'], style: const TextStyle(fontWeight: FontWeight.w500)),
            ],
          ),
          
          const Divider(height: 32),

          // Total & Tombol Aksi
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Total Pesanan:", style: TextStyle(fontSize: 10, color: Colors.grey)),
                  Text(order['total'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ],
              ),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  elevation: 0,
                ),
                child: Text(order['status'] == "Selesai" ? "Tulis Ulasan" : "Lihat Detail"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}