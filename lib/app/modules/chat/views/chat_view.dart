import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:space_texting/app/modules/chat/views/bubble_chat.dart';
import 'package:space_texting/app/routes/app_pages.dart';
import 'package:space_texting/constants/assets.dart';

class ChatView extends StatefulWidget {
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
  _ChatViewState createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  late PageController _pageController;
  late Timer _timer;

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
    _startImageRotation();
  }

  void _startImageRotation() {
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_pageController.hasClients) {
        final nextPage =
            (_pageController.page! + 1).toInt() % _imagePaths.length;
        _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
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
    _timer.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image rotation
          PageView.builder(
            controller: _pageController,
            itemCount: _imagePaths.length,
            itemBuilder: (context, index) {
              return Image.asset(
                _imagePaths[index],
                fit: BoxFit.cover,
              );
            },
            scrollDirection: Axis.horizontal,
          ),

          // Chat content over the background
          Column(
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
                            PopupMenuItem(
                              value: 1,
                              child: Row(
                                children: const [
                                  Icon(Icons.block, color: Colors.white),
                                  SizedBox(width: 10),
                                  Text('Block User',
                                      style: TextStyle(color: Colors.white)),
                                ],
                              ),
                            ),
                            PopupMenuItem(
                              value: 2,
                              child: Row(
                                children: const [
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
                    // Add more ChatBubble widgets as needed
                  ],
                ),
              ),

              // Message input field
              buildMessageInputField(),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildMessageInputField() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: _gradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: const Row(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 5),
            child: Icon(Icons.add_circle_outline_rounded, color: Colors.white),
          ),
          SizedBox(width: 16),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: "Type a message...",
                hintStyle: TextStyle(color: Colors.white),
                border: InputBorder.none,
              ),
              style: TextStyle(color: Colors.white),
            ),
          ),
          SizedBox(width: 16),
          Icon(Icons.send, color: Colors.white),
        ],
      ),
    );
  }
}
