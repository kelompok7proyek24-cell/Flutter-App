// Path: lib/features/order/presentation/pages/my_orders_page.dart

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../../../core/constants/colors.dart';

enum OrderStatus { dikemas, dikirim, selesai }

class OrderItem {
  final String id;
  final String productName;
  final String variant;
  final int price; 
  final int quantity;
  final String imagePath;
  final String shopName;
  final String deliveryDateInfo; 
  OrderStatus status; 

  OrderItem({
    required this.id,
    required this.productName,
    required this.variant,
    required this.price,
    required this.quantity,
    required this.imagePath,
    required this.shopName,
    required this.deliveryDateInfo,
    required this.status,
  });
}

class MyOrdersPage extends StatefulWidget {
  final int initialTab; 
  final List<OrderItem>? incomingOrders; 

  const MyOrdersPage({
    super.key, 
    this.initialTab = 0,
    this.incomingOrders, 
  });

  @override
  State<MyOrdersPage> createState() => _MyOrdersPageState();
}

class _MyOrdersPageState extends State<MyOrdersPage> {
  List<OrderItem> _dummyOrders = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadOrderHistory();
  }

  Future<void> _loadOrderHistory() async {
    setState(() => _isLoading = true);
    
    final prefs = await SharedPreferences.getInstance();
    final List<String> riwayatString = prefs.getStringList('history_orders') ?? [];
    List<OrderItem> loadedOrders = [];

    if (widget.incomingOrders != null) {
      loadedOrders.addAll(widget.incomingOrders!);
    }

    for (String itemStr in riwayatString) {
      try {
        final Map<String, dynamic> map = jsonDecode(itemStr);
        final List<dynamic> itemsList = map['items'] ?? [];

        for (var item in itemsList) {
          loadedOrders.add(
            OrderItem(
              id: map['id_pesanan'] ?? 'ORD-UNKNOWN',
              productName: item['name'] ?? '',
              variant: item['variant'] ?? 'Normal',
              price: item['price'] ?? 0,
              quantity: item['quantity'] ?? 1,
              imagePath: item['imagePath'] ?? '',
              shopName: 'Arwana Shop', 
              deliveryDateInfo: 'Dibuat pada: ${map['tanggal']}',
              status: _parseStatus(map['status'] ?? 'Dikemas'),
            ),
          );
        }
      } catch (e) {
        debugPrint("Error parsing order item: $e");
      }
    }

    setState(() {
      _dummyOrders = loadedOrders;
      _isLoading = false;
    });
  }

  OrderStatus _parseStatus(String statusStr) {
    if (statusStr == 'Dikirim') return OrderStatus.dikirim;
    if (statusStr == 'Selesai') return OrderStatus.selesai;
    return OrderStatus.dikemas;
  }

  Future<void> _updateLocalHistoryStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> riwayatString = prefs.getStringList('history_orders') ?? [];
    List<String> updatedRiwayat = [];

    for (String itemStr in riwayatString) {
      Map<String, dynamic> map = jsonDecode(itemStr);
      String currentOrderId = map['id_pesanan'];
      
      final matchingUIOrder = _dummyOrders.firstWhere(
        (o) => o.id == currentOrderId, 
        orElse: () => OrderItem(id: '', productName: '', variant: '', price: 0, quantity: 0, imagePath: '', shopName: '', deliveryDateInfo: '', status: OrderStatus.dikemas)
      );

      if (matchingUIOrder.id.isNotEmpty) {
        map['status'] = _getStatusText(matchingUIOrder.status);
      }
      updatedRiwayat.add(jsonEncode(map));
    }
    
    await prefs.setStringList('history_orders', updatedRiwayat);
  }

  void _batalkanPesanan(String id) async {
    setState(() {
      _dummyOrders.removeWhere((order) => order.id == id);
    });
    
    final prefs = await SharedPreferences.getInstance();
    final List<String> riwayatString = prefs.getStringList('history_orders') ?? [];
    riwayatString.removeWhere((itemStr) {
      final map = jsonDecode(itemStr);
      return map['id_pesanan'] == id;
    });
    await prefs.setStringList('history_orders', riwayatString);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Pesanan berhasil dibatalkan & dana di-refund.")),
      );
    }
  }

  /// REKAYASA SISTEM: Menangani simulasi perpindahan alur dari Dikemas -> Dikirim
  void _simulasiKirimBarang(String id) async {
    setState(() {
      final order = _dummyOrders.firstWhere((o) => o.id == id);
      order.status = OrderStatus.dikirim;
    });
    
    await _updateLocalHistoryStorage();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Simulasi Berhasil: Kurir sedang mengantar ikanmu!")),
      );
    }
  }

  void _konfirmasiDiterima(String id) async {
    setState(() {
      final order = _dummyOrders.firstWhere((o) => o.id == id);
      order.status = OrderStatus.selesai;
    });
    
    await _updateLocalHistoryStorage();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Status pesanan diperbarui menjadi Selesai.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4, 
      initialIndex: widget.initialTab, 
      child: Scaffold(
        backgroundColor: const Color(0xffF5F7FA), 
        appBar: AppBar(
          title: const Text(
            "Pesanan Saya",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0.5,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
          bottom: const TabBar(
            isScrollable: false,
            labelColor: AppColors.primaryBlue,
            unselectedLabelColor: Colors.grey,
            indicatorColor: AppColors.primaryBlue,
            tabs: [
              Tab(text: "Semua"),
              Tab(text: "Dikemas"),
              Tab(text: "Dikirim"),
              Tab(text: "Selesai"),
            ],
          ),
        ),
        body: _isLoading 
          ? const Center(child: CircularProgressIndicator(color: AppColors.primaryBlue))
          : TabBarView(
              children: [
                _buildOrderList(null), 
                _buildOrderList(OrderStatus.dikemas),
                _buildOrderList(OrderStatus.dikirim),
                _buildOrderList(OrderStatus.selesai),
              ],
            ),
      ),
    );
  }

  Widget _buildOrderList(OrderStatus? filterStatus) {
    final filteredList = filterStatus == null
        ? _dummyOrders
        : _dummyOrders.where((order) => order.status == filterStatus).toList();

    if (filteredList.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.assignment_outlined, size: 64, color: Colors.grey[300]),
            const SizedBox(height: 12),
            Text(
              "Tidak ada pesanan",
              style: TextStyle(color: Colors.grey[400], fontWeight: FontWeight.w500),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: filteredList.length,
      itemBuilder: (context, index) {
        final order = filteredList[index];
        return _buildOrderCard(order);
      },
    );
  }

  Widget _buildOrderCard(OrderItem order) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.storefront, size: 18, color: AppColors.primaryBlue),
                  const SizedBox(width: 6),
                  Text(
                    order.shopName,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                ],
              ),
              Text(
                _getStatusText(order.status),
                style: TextStyle(
                  color: _getStatusColor(order.status),
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const Divider(height: 20, thickness: 0.5),

          Row(
            children: [
              const Icon(Icons.local_shipping_outlined, size: 16, color: Colors.grey),
              const SizedBox(width: 8),
              Expanded(
                child: Text(order.deliveryDateInfo, style: const TextStyle(fontSize: 12, color: Colors.grey)),
              ),
              const Icon(Icons.chevron_right, size: 16, color: Colors.grey),
            ],
          ),
          const SizedBox(height: 12),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  order.imagePath,
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    width: 60,
                    height: 60,
                    color: Colors.blue[50],
                    child: const Icon(Icons.set_meal, color: AppColors.primaryBlue),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      order.productName,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      "Varian: ${order.variant}",
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                    Text(
                      "x${order.quantity}",
                      style: const TextStyle(color: Colors.black54, fontSize: 12),
                    ),
                  ],
                ),
              ),
              Text(
                "Rp ${order.price}",
                style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
              ),
            ],
          ),
          const Divider(height: 24, thickness: 0.5),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Total Pesanan:", style: TextStyle(fontSize: 10, color: Colors.grey)),
                  Text(
                    "Rp ${order.price * order.quantity}", 
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)
                  ),
                ],
              ),
              Row(
                children: _buildActionButtons(order),
              ),
            ],
          )
        ],
      ),
    );
  }

  List<Widget> _buildActionButtons(OrderItem order) {
    if (order.status == OrderStatus.dikemas) {
      return [
        OutlinedButton(
          onPressed: () => _batalkanPesanan(order.id),
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: Colors.redAccent),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          child: const Text("Batalkan", style: TextStyle(color: Colors.redAccent, fontSize: 12)),
        ),
        const SizedBox(width: 6),
        // SINKRONISASI BARU: Tombol Simulasi untuk meloloskan status ke fase berikutnya
        ElevatedButton(
          onPressed: () => _simulasiKirimBarang(order.id),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            elevation: 0,
          ),
          child: const Text("Simulasi Kirim", style: TextStyle(color: Colors.white, fontSize: 12)),
        ),
      ];
    } else if (order.status == OrderStatus.dikirim) {
      return [
        OutlinedButton(
          onPressed: () {},
          style: OutlinedButton.styleFrom(
            side: BorderSide(color: Colors.grey.shade300),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          child: const Text("Chat", style: TextStyle(color: Colors.black87, fontSize: 12)),
        ),
        const SizedBox(width: 6),
        ElevatedButton(
          onPressed: () => _konfirmasiDiterima(order.id),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryBlue,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            elevation: 0,
          ),
          child: const Text("Pesanan Diterima", style: TextStyle(color: Colors.white, fontSize: 12)),
        ),
      ];
    } else {
      return [
        ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryBlue,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            elevation: 0,
          ),
          child: const Text("Tulis Ulasan", style: TextStyle(color: Colors.white, fontSize: 12)),
        ),
      ];
    }
  }

  String _getStatusText(OrderStatus status) {
    switch (status) {
      case OrderStatus.dikemas: return "Dikemas";
      case OrderStatus.dikirim: return "Dikirim";
      case OrderStatus.selesai: return "Selesai";
    }
  }

  Color _getStatusColor(OrderStatus status) {
    switch (status) {
      case OrderStatus.dikemas: return Colors.orange;
      case OrderStatus.dikirim: return AppColors.primaryBlue;
      case OrderStatus.selesai: return Colors.green;
    }
  }
}