import 'dart:async';
import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:giphy_get/giphy_get.dart';
import 'package:space_texting/app/components/custom_button.dart';
import 'package:space_texting/app/modules/chat/controllers/chat_controller.dart';
import 'package:space_texting/app/modules/chat/views/bubble_chat.dart';
import 'package:space_texting/app/routes/app_pages.dart';
import 'package:space_texting/app/services/responsive_size.dart';
import 'package:space_texting/constants/assets.dart';

class ChatView extends StatefulWidget {
  final String name;
  final String profileImage;
  final bool isOnline;
  final String targetUserId;
  final String userId;

  const ChatView({
    Key? key,
    required this.name,
    required this.profileImage,
    this.isOnline = false,
    required this.targetUserId,
    required this.userId,
  }) : super(key: key);

  @override
  _ChatViewState createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  late PageController _pageController;

  ChatController chatController = Get.put(ChatController());
  final _messageController = TextEditingController();

  final List<String> _imagePaths = [
    Assets.assetsBg1,
    Assets.assetsBg2,
    Assets.assetsBg3,
    Assets.assetsBg4,
  ];

  late List<Color> _gradientColors;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _gradientColors = _generateRandomGradientColors();

    chatController.connectSocket(widget.userId, widget.targetUserId);
  }

  List<Color> _generateRandomGradientColors() {
    final Random random = Random();
    final double hue =
        random.nextDouble() * 360; // Random hue between 0 and 360
    final double saturation =
        0.5 + random.nextDouble() * 0.5; // Random saturation between 0.5 and 1
    final double lightness = 0.5; // Fixed lightness to ensure readability

    Color color1 = HSLColor.fromAHSL(1.0, hue, saturation, lightness).toColor();
    Color color2 =
        HSLColor.fromAHSL(1.0, (hue + 30) % 360, saturation, lightness)
            .toColor(); // Slightly different hue

    return [color1, color2];
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => SizedBox(
          height: Get.height,
          width: Get.width,
          child: Column(
            children: [
              // Gradient AppBar with rounded corners
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: _gradientColors,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(25),
                    bottomRight: Radius.circular(25),
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12.0, vertical: 8),
                    child: Row(
                      children: [
                        IconButton(
                          icon:
                              const Icon(Icons.arrow_back, color: Colors.white),
                          onPressed: () {
                            Get.back(); // Navigate back to the previous screen
                          },
                        ),
                        GestureDetector(
                          onTap: () {
                            Get.toNamed(Routes.VIEW_PROFILE);
                          },
                          child: Row(
                            children: [
                              CircleAvatar(
                                backgroundImage:
                                    NetworkImage(widget.profileImage),
                                radius: 24,
                              ),
                              const SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.name,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    widget.isOnline ? 'Online' : 'Offline',
                                    style: TextStyle(
                                      color: widget.isOnline
                                          ? Colors.greenAccent
                                          : Colors.grey[300],
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const Spacer(),
                        InkWell(
                            onTap: () {
                              Get.toNamed(Routes.VIDEO_CALL, arguments: {
                                "callId": "joysarkarcalltest",
                                "receiverId": "joysarkar",
                                'isCaller': false,
                              });
                            },
                            child: const Icon(Icons.call, color: Colors.white)),
                        const SizedBox(width: 20),
                        InkWell(
                            onTap: () {
                              Get.toNamed(Routes.VIDEO_CALL, arguments: {
                                "callId": "joysarkarcalltest",
                                "receiverId": "joysarkar",
                                'isCaller': true,
                              });
                            },
                            child: const Icon(Icons.videocam,
                                color: Colors.white)),
                        const SizedBox(width: 20),
                        PopupMenuButton<int>(
                          icon: const Icon(Icons.more_vert,
                              color: Colors.white), // More options icon
                          color: const Color.fromARGB(255, 44, 40, 40)
                              .withOpacity(
                                  0.8), // Set the background color with opacity
                          itemBuilder: (context) => [
                            const PopupMenuItem(
                              value: 1,
                              child: Row(
                                children: [
                                  Icon(Icons.block, color: Colors.white),
                                  SizedBox(width: 10),
                                  Text('Block User',
                                      style: TextStyle(color: Colors.white)),
                                ],
                              ),
                            ),
                            const PopupMenuItem(
                              value: 2,
                              child: Row(
                                children: [
                                  Icon(Icons.chat_bubble_outline,
                                      color: Colors.white),
                                  SizedBox(width: 10),
                                  Text('Clear Chat',
                                      style: TextStyle(color: Colors.white)),
                                ],
                              ),
                            ),
                          ],
                          onSelected: (value) {
                            if (value == 1) {
                              // Handle Block User action
                              print('Block User');
                            } else if (value == 2) {
                              // Handle Clear Chat action
                              print('Clear Chat');
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Chat list (Chat messages)
              Expanded(
                child: Stack(
                  children: [
                    Center(
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Today',
                          style: TextStyle(color: Colors.white54, fontSize: 14),
                        ),
                      ),
                    ),
                    ...chatController.messages
                        .sublist(
                          chatController.messages.length >= 5
                              ? chatController.messages.length - 5
                              : 0,
                        )
                        .map(
                          (element) => ChatBubble(
                            isSender: element['isSender'] ??
                                false, // Assuming messages have 'isSender' field
                            text:
                                "${element["message"]}", // Assuming messages have 'message' field
                            time:
                                "7:10 AM", // Adjust time based on the message if needed
                          ),
                        ),
                  ],
                ),
              ),

              // Message input field
              buildMessageInputField(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildMessageInputField() {
    return Container(
      height: 50,
      width: Get.width,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: _gradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: const InputDecoration(
                hintText: 'Type a message...',
                border: InputBorder.none,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send, color: Colors.white),
            onPressed: () {
              String message = _messageController.text.trim();
              if (message.isNotEmpty) {
                chatController.sendMessage(
                    widget.userId, widget.targetUserId, message);
                _messageController.clear();
              }
            },
          ),
        ],
      ),
    );
  }
}
