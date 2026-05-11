// lib/features/chat/presentation/pages/message_list_page.dart
import 'package:flutter/material.dart';
import 'chat_page.dart';

class MessageListPage extends StatelessWidget {
  const MessageListPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Data Dummy sesuai desain "PESAN/NOTIF" yang kamu kirim
    final List<Map<String, dynamic>> chats = [
      {"name": "AQUA PARADISE", "lastMsg": "PAYDAY DEALS EXTRA FREE VOUCHER!", "unread": 2},
      {"name": "AquaGrace", "lastMsg": "Your order has been shipped! Check...", "unread": 1},
      {"name": "Fin-tastic Aquatic", "lastMsg": "Hi, the item is currently out of stock.", "unread": 0},
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Pesan & Notifikasi", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: const BackButton(color: Colors.black),
      ),
      body: ListView.separated(
        itemCount: chats.length,
        separatorBuilder: (context, index) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final chat = chats[index];
          return ListTile(
            leading: const CircleAvatar(radius: 25, backgroundColor: Colors.blue),
            title: Text(chat['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(chat['lastMsg'], maxLines: 1, overflow: TextOverflow.ellipsis),
            trailing: chat['unread'] > 0 
              ? CircleAvatar(radius: 10, backgroundColor: Colors.blue, 
                  child: Text("${chat['unread']}", style: const TextStyle(color: Colors.white, fontSize: 10)))
              : const Text("Yesterday", style: TextStyle(fontSize: 10, color: Colors.grey)),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ChatPage(shopName: chat['name'])),
              );
            },
          );
        },
      ),
    );
  }
}