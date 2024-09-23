import 'dart:math';
import 'package:flutter/material.dart';

class ChatBubble extends StatefulWidget {
  final String text;
  final bool isSender;
  final String time;
  final bool hasImage;
  final String? imagePath;

  const ChatBubble({
    Key? key,
    required this.text,
    required this.isSender,
    required this.time,
    this.hasImage = false,
    this.imagePath,
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
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
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
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: widget.hasImage && widget.imagePath != null
                          ? Column(
                              children: [
                                Text(
                                  widget.text,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 8),
                                Image.asset(widget.imagePath!,
                                    width: 40, height: 40),
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
