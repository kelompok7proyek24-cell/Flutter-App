import 'package:flutter/material.dart';
import '../../../../core/constants/colors.dart';
import '../widgets/fish_card.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
     
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.primaryBlue,
        unselectedItemColor: Colors.grey,
        currentIndex: 0,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_bag), label: 'Produk'),
          BottomNavigationBarItem(icon: Icon(Icons.article), label: 'Artikel'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Keranjang'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Akun'),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Icon(Icons.settings_outlined, color: AppColors.primaryBlue),
                    Expanded(
                      child: Center(
                        child: Text("IKANKU.ID", 
                          style: TextStyle(color: AppColors.primaryBlue, fontWeight: FontWeight.bold, fontSize: 18)),
                      ),
                    ),
                    
                    Stack(
                      children: [
                        Icon(Icons.shopping_cart_outlined, color: AppColors.primaryBlue),
                        Positioned(
                          right: 0,
                          child: CircleAvatar(radius: 6, backgroundColor: Colors.red, child: Text("2", style: TextStyle(fontSize: 8, color: Colors.white))),
                        )
                      ],
                    ),
                  ],
                ),
              ),

              // 2. Search Bar
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "Cari ikan terbaikmu..",
                    prefixIcon: Icon(Icons.search),
                    filled: true,
                    fillColor: Colors.grey[100],
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                  ),
                ),
              ),

              // 3. Banner Biru (IKANKU.ID)
              Container(
                margin: EdgeInsets.all(16.0),
                height: 150,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.primaryBlue,
                  borderRadius: BorderRadius.circular(15),
                  image: DecorationImage(
                    image: AssetImage('assets/images/banner_bg.png'), // Gunakan asset bawaan
                    fit: BoxFit.cover,
                  ),
                ),
                child: Center(
                  child: Text("IKANKU.ID", style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
                ),
              ),

              // 4. Section Produk Unggulan
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Produk unggulan", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    Text("Lebih banyak", style: TextStyle(color: AppColors.primaryBlue, fontSize: 12)),
                  ],
                ),
              ),

              // 5. List Produk (Horizontal)
              Container(
                height: 220,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.only(left: 16),
                  children: [
                    FishCard(name: "Red Ryukin Goldfish", price: "Rp25.000", rating: "4.8"),
                    FishCard(name: "Red Ryukin Goldfish", price: "Rp25.000", rating: "4.8"),
                  ],
                ),
              ),

              // 6. Section Perawatan Ikan (Artikel)
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Text("Perawatan ikan", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
              
              // Artikel Card
              Container(
                margin: EdgeInsets.symmetric(horizontal: 16),
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade200),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Container(width: 60, height: 60, color: Colors.green[200], child: Icon(Icons.eco)),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("5 Tips for a Perfect Tank Ecosystem", style: TextStyle(fontWeight: FontWeight.bold)),
                          Text("Learn how to balance pH and nitrate levels easily.", style: TextStyle(fontSize: 12, color: Colors.grey)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}