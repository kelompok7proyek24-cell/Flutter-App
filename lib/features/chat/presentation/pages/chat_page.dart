import 'package:flutter/material.dart';

// --------------------------------------------------------
// MODEL DATA (Diletakkan di luar class agar bisa diakses)
// --------------------------------------------------------
class ChatMessage {
  final String text;
  final bool isMe;
  final String time;

  ChatMessage({
    required this.text,
    required this.isMe,
    required this.time,
  });
}

class ChatPage extends StatefulWidget {
  final String shopName;
  const ChatPage({super.key, required this.shopName});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _controller = TextEditingController();
  
  final List<ChatMessage> _messages = [
    ChatMessage(text: "Those look amazing! How much for a breeding pair?", isMe: true, time: "09:46 AM"),
    ChatMessage(text: "Sure, here is a photo of the tank from this morning. They are very active!", isMe: false, time: "09:45 AM"),
    ChatMessage(text: "Yes, I am! Do you have more photos of the current stock?", isMe: true, time: "09:43 AM"),
    ChatMessage(text: "Hello! Are you interested in the Red Dragon Guppies?", isMe: false, time: "09:41 AM"),
  ];

  void _sendMessage() {
    if (_controller.text.trim().isEmpty) return;
    
    setState(() {
      _messages.insert(0, ChatMessage(
        text: _controller.text,
        isMe: true,
        time: "Now",
      ));
    });
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.5,
        title: Row(
          children: [
            const CircleAvatar(radius: 18, backgroundColor: Colors.blue),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.shopName, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const Text("Online", style: TextStyle(fontSize: 12, color: Colors.green)),
              ],
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                return _buildChatBubble(msg);
              },
            ),
          ),
          _buildInputBar(),
        ],
      ),
    );
  }

  Widget _buildChatBubble(ChatMessage msg) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: msg.isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!msg.isMe) const CircleAvatar(radius: 12, backgroundColor: Colors.grey),
          const SizedBox(width: 8),
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: msg.isMe ? Colors.blue : Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Text(
                msg.text,
                style: TextStyle(color: msg.isMe ? Colors.white : Colors.black87),
              ),
            ),
          ),
          if (msg.isMe) const SizedBox(width: 8),
          if (msg.isMe) const CircleAvatar(radius: 12, backgroundColor: Colors.orangeAccent),
        ],
      ),
    );
  }

  Widget _buildInputBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  hintText: "Type a message...",
                  filled: true,
                  fillColor: Colors.grey[100],
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(25), borderSide: BorderSide.none),
                ),
              ),
            ),
            const SizedBox(width: 12),
            GestureDetector(
              onTap: _sendMessage,
              child: const CircleAvatar(
                backgroundColor: Colors.blue,
                child: Icon(Icons.send, color: Colors.white, size: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}