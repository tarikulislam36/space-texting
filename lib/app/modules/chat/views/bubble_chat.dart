import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:space_texting/app/components/gif_video_player.dart';
import 'package:space_texting/app/modules/chat/controllers/chat_controller.dart';
import 'package:space_texting/app/routes/app_pages.dart';

class ChatBubble extends StatefulWidget {
  final String text;
  final int isSender;
  final String time;
  final bool hasImage;
  final String type;
  final String date;
  final String senderName;
  final String receiverId;

  const ChatBubble({
    Key? key,
    required this.text,
    required this.isSender,
    required this.time,
    this.hasImage = false,
    required this.type,
    required this.senderName,
    required this.date,
    required this.receiverId,
  }) : super(key: key);

  @override
  _ChatBubbleState createState() => _ChatBubbleState();
}

class _ChatBubbleState extends State<ChatBubble>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Color bubbleColor;
  Offset _bubblePosition = Offset.zero;
  Offset _movementOffset = Offset.zero;
  Random random = Random();
  bool showDeleteIcon = false;

  double screenWidth = 0;
  double screenHeight = 0;

  // Fixed speed for movement
  final double speed = 0.3;

  @override
  void initState() {
    super.initState();

    // Initialize the Animation Controller
    _controller = AnimationController(
      duration: const Duration(days: 1), // Keep it running indefinitely
      vsync: this,
    )..repeat(); // Loop the animation

    // Initialize bubble color
    bubbleColor = _getRandomColor();

    // Set initial random position after first frame is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _bubblePosition = _getRandomPosition();
        _movementOffset =
            _getRandomMovementOffset(); // Initialize movement offset
      });
    });

    // Start the animation
    _controller.addListener(() {
      setState(() {
        // Update bubble position based on movement offset
        _bubblePosition += _movementOffset * speed;

        // Check for screen bounds and reverse direction if needed
        if (_bubblePosition.dx < 0 || _bubblePosition.dx > screenWidth - 120) {
          _movementOffset = Offset(
              -_movementOffset.dx, _movementOffset.dy); // Reverse X direction
        }
        if (_bubblePosition.dy < 0 || _bubblePosition.dy > screenHeight - 120) {
          _movementOffset = Offset(
              _movementOffset.dx, -_movementOffset.dy); // Reverse Y direction
        }
      });
    });

    // Start the animation
    _controller.forward();
  }

  // Function to generate a random color
  Color _getRandomColor() {
    int r = random.nextInt(150) + 50;
    int g = random.nextInt(150) + 50;
    int b = random.nextInt(150) + 50;
    return Color.fromRGBO(r, g, b, 1);
  }

  // Function to generate a random position for the bubble within screen bounds
  Offset _getRandomPosition() {
    final double maxX = screenWidth - 120; // Subtract bubble size
    final double maxY = screenHeight - 120; // Subtract bubble size

    return Offset(
      random.nextDouble() * maxX,
      random.nextDouble() * maxY,
    );
  }

  // Function to generate random movement offsets for each bubble
  Offset _getRandomMovementOffset() {
    double moveX = (random.nextDouble() * 2 + 1) *
        (random.nextBool() ? 1 : -1); // Move -2 to +2
    double moveY = (random.nextDouble() * 2 + 1) *
        (random.nextBool() ? 1 : -1); // Move -2 to +2
    return Offset(moveX, moveY);
  }

  // Function to handle long press event
  void _onLongPress() {
    _controller.stop(); // Stop the bubble animation
    setState(() {
      showDeleteIcon = true; // Show the delete icon
    });
  }

  // Function to handle long press release event
  void _onLongPressEnd() {
    Future.delayed(const Duration(seconds: 0), () {
      setState(() {
        showDeleteIcon = false; // Hide the delete icon after 3 seconds
        _controller.forward(); // Resume the animation
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // Get screen size for positioning bubbles randomly
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height - 180;

    // Check if the message contains only emojis
    bool isEmojiOnly = widget.type == "message" &&
        RegExp(
          r"^[\u{1F600}-\u{1F64F}\u{1F300}-\u{1F5FF}\u{1F680}-\u{1F6FF}\u{2600}-\u{26FF}\u{2700}-\u{27BF}\u{1F1E6}-\u{1F1FF}\u{1F900}-\u{1F9FF}\u{1FA70}-\u{1FAFF}\u{1F000}-\u{1F02F}\u{1F0A0}-\u{1F0FF}\u{1F170}-\u{1F251}]+$",
          unicode: true,
        ).hasMatch(widget.text);

    return Stack(
      children: [
        Positioned(
          left: _bubblePosition.dx,
          top: _bubblePosition.dy,
          child: GestureDetector(
            onLongPress: _onLongPress,
            onDoubleTap: () => _onLongPressEnd(),
            child: Column(
              crossAxisAlignment: widget.isSender == 1
                  ? CrossAxisAlignment.start
                  : CrossAxisAlignment.end,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: isEmojiOnly
                          ? 240
                          : widget.type == "gif"
                              ? 190
                              : widget.text.length > 40
                                  ? 200
                                  : 120,
                      height: isEmojiOnly
                          ? 240
                          : widget.type == "gif"
                              ? 190
                              : widget.text.length > 40
                                  ? 200
                                  : 120,
                      decoration: isEmojiOnly
                          ? null // No gradient for emoji-only messages
                          : widget.type == "message"
                              ? BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: RadialGradient(
                                    colors: [
                                      Colors.white70,
                                      bubbleColor,
                                    ],
                                    center: Alignment.center,
                                    radius: 0.8,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.3),
                                      offset: const Offset(4, 4),
                                      blurRadius: 10,
                                    ),
                                  ],
                                )
                              : null,
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: isEmojiOnly
                              ? Text(
                                  widget.text.runes.length > 1
                                      ? String.fromCharCode(
                                          widget.text.runes.first)
                                      : widget.text,
                                  style: const TextStyle(
                                    fontSize: 114, // Large text size for emojis
                                  ),
                                )
                              : widget.type == "gif"
                                  ? Padding(
                                      padding: const EdgeInsets.all(2.0),
                                      child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(4),
                                          child: GifVideoPlayer(
                                              videoUrl: widget.text)),
                                    )
                                  : widget.type == "photo"
                                      ? InkWell(
                                          onTap: () {
                                            Get.toNamed(Routes.SHOW_IMAGE,
                                                arguments: {
                                                  "img": widget.text,
                                                });
                                          },
                                          child: Image.network(
                                            widget.text,
                                            fit: BoxFit.cover,
                                            errorBuilder:
                                                (context, error, stackTrace) =>
                                                    const Icon(Icons.error),
                                          ),
                                        )
                                      : widget.type == "document"
                                          ? Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                const Icon(
                                                  Icons.insert_drive_file,
                                                  size: 50,
                                                  color: Colors.white70,
                                                ),
                                                const SizedBox(height: 8),
                                                Text(
                                                  widget.text,
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 12,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ],
                                            )
                                          : Text(
                                              widget.text,
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 14,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                        ),
                      ),
                    ),
                    // Delete icon shown during long press
                    if (showDeleteIcon)
                      Positioned(
                        top: 1,
                        right: 10,
                        child: InkWell(
                          onTap: () {
                            Get.find<ChatController>().deleteMessage(
                                widget.text, widget.date, widget.time);
                            Get.find<ChatController>()
                                .socketService
                                .deleteMessage(
                                    widget.text, widget.date, widget.time);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.white, shape: BoxShape.circle),
                            child: Icon(
                              Icons.cancel,
                              color: Colors.red,
                              size: 30,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Row(
                    children: [
                      Text(
                        widget.isSender == 1 ? "Me " : widget.senderName + "  ",
                        style: const TextStyle(
                            color: Colors.white54, fontSize: 12),
                      ),
                      Text(
                        widget.time,
                        style: const TextStyle(
                            color: Colors.white54, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
