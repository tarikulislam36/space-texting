import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:space_texting/app/modules/chat/views/chat_view.dart';
import 'package:space_texting/app/routes/app_pages.dart';
import 'package:space_texting/app/services/responsive_size.dart';
import 'package:space_texting/constants/assets.dart';

import '../controllers/chat_screen_controller.dart';

// Reusable ChatCard widget
class ChatCard extends StatelessWidget {
  final String name;
  final String message;
  final String time;
  final bool isUnread;
  final bool isTyping;
  final int unreadCount;
  final String profileImage;
  final bool isOnline;

  const ChatCard({
    Key? key,
    required this.name,
    required this.message,
    required this.time,
    this.isUnread = false,
    this.isTyping = false,
    this.unreadCount = 0,
    required this.profileImage,
    this.isOnline = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Stack(
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(profileImage), // Profile Image
            radius: 25,
          ),
          if (isOnline)
            Positioned(
              bottom: 0,
              right: 0,
              child: CircleAvatar(
                backgroundColor: Colors.green,
                radius: 6,
              ),
            ),
        ],
      ),
      title: Text(
        name,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      subtitle: Text(
        isTyping ? 'typing...' : message,
        style: TextStyle(
          fontSize: 14,
          color: isTyping ? Colors.greenAccent : Colors.grey[400],
        ),
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            time,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[400],
            ),
          ),
          if (isUnread)
            CircleAvatar(
              backgroundColor: Colors.blueAccent,
              radius: 10,
              child: Text(
                '$unreadCount',
                style: const TextStyle(
                  fontSize: 10,
                  color: Colors.white,
                ),
              ),
            ),
        ],
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
      onTap: () {
        // Navigate to ChatView and pass necessary data
        Get.to(() => ChatView(
              name: name,
              profileImage: profileImage,
              isOnline: isOnline,
            ));
      },
    );
  }
}

// Main Chat Screen with Background and List of Chat Cards
class ChatScreenView extends GetView<ChatScreenController> {
  const ChatScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: 100.h,
        width: 100.w,
        padding: const EdgeInsets.only(top: 10),
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(Assets.assetsBackground),
            fit: BoxFit.cover,
          ),
        ),
        child: ListView(
          children: const [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Chats",
                  style: TextStyle(
                      color: Colors.white70,
                      fontSize: 26,
                      fontWeight: FontWeight.w600),
                ),
              ],
            ),
            ChatCard(
              name: 'Name, 18',
              message: 'Kinda nothing, just playing Fortnite...',
              time: 'Now',
              isUnread: true,
              unreadCount: 1,
              profileImage:
                  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSCp_ByMCZW8m0s3KmAbIENDvR2Zc_HkBJyYw&s',
              isOnline: true,
            ),
            ChatCard(
              name: 'Name, 21',
              message: '',
              time: '2 min',
              isTyping: true,
              profileImage:
                  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSqW5lCXxflY_ZOsSs11cRIOoOwTTYHjy0_8A&s',
              isOnline: true,
            ),
            // Add more ChatCards here...
            ChatCard(
              name: 'Name, 18',
              message: 'Kinda nothing, just playing Fortnite...',
              time: 'Now',
              isUnread: true,
              unreadCount: 1,
              profileImage:
                  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSCp_ByMCZW8m0s3KmAbIENDvR2Zc_HkBJyYw&s',
              isOnline: true,
            ),
            ChatCard(
              name: 'Name, 21',
              message: '',
              time: '2 min',
              isTyping: true,
              profileImage:
                  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSqW5lCXxflY_ZOsSs11cRIOoOwTTYHjy0_8A&s',
              isOnline: true,
            ),
            ChatCard(
              name: 'Name, 18',
              message: 'Kinda nothing, just playing Fortnite...',
              time: 'Now',
              isUnread: true,
              unreadCount: 1,
              profileImage:
                  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSCp_ByMCZW8m0s3KmAbIENDvR2Zc_HkBJyYw&s',
              isOnline: true,
            ),
            ChatCard(
              name: 'Name, 21',
              message: '',
              time: '2 min',
              isTyping: true,
              profileImage:
                  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSqW5lCXxflY_ZOsSs11cRIOoOwTTYHjy0_8A&s',
              isOnline: true,
            ),
            ChatCard(
              name: 'Name, 18',
              message: 'Kinda nothing, just playing Fortnite...',
              time: 'Now',
              isUnread: true,
              unreadCount: 1,
              profileImage:
                  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSCp_ByMCZW8m0s3KmAbIENDvR2Zc_HkBJyYw&s',
              isOnline: true,
            ),
            ChatCard(
              name: 'Name, 21',
              message: '',
              time: '2 min',
              isTyping: true,
              profileImage:
                  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSqW5lCXxflY_ZOsSs11cRIOoOwTTYHjy0_8A&s',
              isOnline: true,
            ),
            ChatCard(
              name: 'Name, 18',
              message: 'Kinda nothing, just playing Fortnite...',
              time: 'Now',
              isUnread: true,
              unreadCount: 1,
              profileImage:
                  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSCp_ByMCZW8m0s3KmAbIENDvR2Zc_HkBJyYw&s',
              isOnline: true,
            ),
            ChatCard(
              name: 'Name, 21',
              message: '',
              time: '2 min',
              isTyping: true,
              profileImage:
                  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSqW5lCXxflY_ZOsSs11cRIOoOwTTYHjy0_8A&s',
              isOnline: true,
            ),

            ChatCard(
              name: 'Name, 18',
              message: 'Kinda nothing, just playing Fortnite...',
              time: 'Now',
              isUnread: true,
              unreadCount: 1,
              profileImage:
                  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSCp_ByMCZW8m0s3KmAbIENDvR2Zc_HkBJyYw&s',
              isOnline: true,
            ),
            ChatCard(
              name: 'Name, 21',
              message: '',
              time: '2 min',
              isTyping: true,
              profileImage:
                  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSqW5lCXxflY_ZOsSs11cRIOoOwTTYHjy0_8A&s',
              isOnline: true,
            ),
          ],
        ),
      ),
    );
  }
}
