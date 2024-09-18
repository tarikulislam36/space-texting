import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:space_texting/app/modules/chat/views/bubble_chat.dart';

class ChatView extends StatelessWidget {
  final String name;
  final String profileImage;
  final bool isOnline;

  const ChatView({
    Key? key,
    required this.name,
    required this.profileImage,
    this.isOnline = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Background color for the screen
      backgroundColor: Colors.black,
      body: Column(
        children: [
          // Gradient AppBar with rounded corners
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.orange, Colors.pinkAccent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(25),
                bottomRight: Radius.circular(25),
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () {
                        Get.back(); // Navigate back to previous screen
                      },
                    ),
                    CircleAvatar(
                      backgroundImage:
                          NetworkImage(profileImage), // Display profile picture
                      radius: 24,
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          isOnline ? 'Online' : 'Offline',
                          style: TextStyle(
                            color: isOnline
                                ? Colors.greenAccent
                                : Colors.grey[300],
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Icon(Icons.call, color: Colors.white),
                    const SizedBox(width: 20),
                    Icon(Icons.videocam, color: Colors.white),
                    const SizedBox(width: 20),
                    Icon(Icons.more_vert, color: Colors.white),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView(
              children: const [
                Center(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Today',
                      style: TextStyle(color: Colors.white54, fontSize: 14),
                    ),
                  ),
                ),
                ChatBubble(
                    isSender: false,
                    text: "Lorem ipsum is a demo text",
                    time: "7:10 AM"),
                ChatBubble(
                    isSender: true,
                    text: "Lorem ipsum is a demo text",
                    time: "7:10 AM"),
                ChatBubble(
                    isSender: false,
                    text: "Lorem ipsum is a demo text",
                    time: "7:10 AM"),
                ChatBubble(
                    isSender: true,
                    text: "Lorem ipsum is a demo text",
                    time: "7:10 AM"),
                ChatBubble(
                    isSender: false,
                    text: "Lorem ipsum is a demo text",
                    time: "7:10 AM"),
                ChatBubble(
                    isSender: true,
                    text: "Lorem ipsum is a demo text",
                    time: "7:10 AM"),
                ChatBubble(
                    isSender: false,
                    text: "Lorem ipsum is a demo text",
                    time: "7:10 AM"),
                ChatBubble(
                    isSender: true,
                    text: "Lorem ipsum is a demo text",
                    time: "7:10 AM"),
                ChatBubble(
                    isSender: false,
                    text: "Lorem ipsum is a demo text",
                    time: "7:10 AM"),
                ChatBubble(
                    isSender: true,
                    text: "Lorem ipsum is a demo text",
                    time: "7:10 AM"),
              ],
            ),
          ),
          buildMessageInputField(),
        ],
      ),
    );
  }

  // Build message input field
  Widget buildMessageInputField() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      color: Colors.white,
      child: Row(
        children: [
          const Icon(Icons.add, color: Colors.orangeAccent),
          const SizedBox(width: 16),
          Expanded(
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Write here...',
                border: InputBorder.none,
              ),
            ),
          ),
          const Icon(Icons.emoji_emotions_outlined, color: Colors.grey),
          const SizedBox(width: 8),
          const Icon(Icons.send, color: Colors.orangeAccent),
        ],
      ),
    );
  }
}
