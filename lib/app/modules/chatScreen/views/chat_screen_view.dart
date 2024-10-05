import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:space_texting/app/components/gif_video_player.dart';
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
    super.key,
    required this.name,
    required this.message,
    required this.time,
    this.isUnread = false,
    this.isTyping = false,
    this.unreadCount = 0,
    required this.profileImage,
    this.isOnline = false,
  });

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
            const Positioned(
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
              targetUserId: "joysarkar",
              userId: "adadasjdkhsa",
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.toNamed(Routes.SELECT_CHAT);
        },
        child: Container(
          height: 60,
          width: 60,
          decoration: BoxDecoration(
              color: Colors.deepPurple,
              borderRadius: BorderRadius.circular(13)),
          child: const Center(
            child: Icon(
              Icons.add,
              color: Colors.white,
              size: 34,
            ),
          ),
        ),
      ),
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
          physics: const BouncingScrollPhysics(),
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
          ],
        ),
      ),
    );
  }
}
