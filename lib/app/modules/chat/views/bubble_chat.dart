import 'dart:math';
import 'package:flutter/material.dart';
import 'package:space_texting/app/components/gif_video_player.dart';

class ChatBubble extends StatefulWidget {
  final String text;
  final bool isSender;
  final String time;
  final bool hasImage;
  final String? imagePath;
  final String type;

  const ChatBubble({
    Key? key,
    required this.text,
    required this.isSender,
    required this.time,
    this.hasImage = false,
    this.imagePath,
    required this.type,
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

  double calculateTextWidth(String text, TextStyle style,
      {double maxWidth = double.infinity}) {
    // Create a TextPainter to measure the width of the text
    final textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      maxLines: 1, // Set to 1 to measure single line width
      textDirection: TextDirection.ltr, // Set the text direction
    );

    textPainter.layout(
        maxWidth: maxWidth); // Layout the text painter to calculate width

    return textPainter.width; // Return the calculated width
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

  @override
  Widget build(BuildContext context) {
    // Get screen size for positioning bubbles randomly
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height - 180;

    return Stack(
      children: [
        Positioned(
          left: _bubblePosition.dx,
          top: _bubblePosition.dy,
          child: GestureDetector(
            onTap: () {
              // Change bubble position when tapped
              setState(() {
                _bubblePosition = _getRandomPosition();
              });
            },
            child: Column(
              crossAxisAlignment: widget.isSender
                  ? CrossAxisAlignment.start
                  : CrossAxisAlignment.end,
              children: [
                Container(
                  width: widget.type == "gif"
                      ? 150
                      : widget.text.length > 40
                          ? 200
                          : 120,
                  height: widget.type == "gif"
                      ? 150
                      : widget.text.length > 40
                          ? 200
                          : 120,
                  decoration: widget.type == "message"
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
                      child: widget.type == "gif"
                          ? Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(4),
                                  child: GifVideoPlayer(videoUrl: widget.text)),
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
                Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Text(
                    widget.time,
                    style: const TextStyle(color: Colors.white54, fontSize: 12),
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
