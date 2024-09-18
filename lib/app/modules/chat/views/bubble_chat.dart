import 'dart:async';
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
  late Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();
    // Initialize the Animation Controller
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true);

    // Slight upward and downward animation
    _offsetAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0, -0.08),
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _offsetAnimation,
      child: Align(
        alignment:
            widget.isSender ? Alignment.centerLeft : Alignment.centerRight,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 5),
          child: Column(
            crossAxisAlignment: widget.isSender
                ? CrossAxisAlignment.start
                : CrossAxisAlignment.end,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: widget.isSender
                        ? [
                            Colors.pinkAccent,
                            Colors.pinkAccent.withOpacity(0.7)
                          ]
                        : [
                            Colors.purpleAccent,
                            Colors.purpleAccent.withOpacity(0.7)
                          ],
                    center: Alignment.center,
                    radius: 0.8,
                  ),
                  // 3D shadow effect
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      offset: const Offset(4, 4), // Shadow position for depth
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
    );
  }
}
