import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:space_texting/app/services/responsive_size.dart';
import '../controllers/video_call_controller.dart';

class VideoCallView extends GetView<VideoCallController> {
  const VideoCallView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          // Show controls when the screen is tapped
          controller.showControls();
        },
        child: Stack(
          children: [
            // Background network image (video placeholder)
            Positioned.fill(
              child: Image.network(
                'https://img.freepik.com/free-photo/man-with-headset-video-call_23-2148854889.jpg', // replace with your network image URL
                fit: BoxFit.cover,
              ),
            ),

            // Top bar with back button
            Positioned(
              top: 50,
              left: 20,
              child: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Get.back(),
              ),
            ),

            // Draggable small participant image
            DraggableParticipantImage(),

            // Bottom control buttons (conditionally visible)
            Obx(() {
              return controller.showingControls.value
                  ? Positioned(
                      bottom: 40,
                      left: 0,
                      right: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // Mute button
                          CircleAvatar(
                            backgroundColor: Colors.black54,
                            child: IconButton(
                              icon: Icon(Icons.mic, color: Colors.white),
                              onPressed: () {
                                // Implement mute functionality
                              },
                            ),
                          ),
                          // Speaker button
                          CircleAvatar(
                            backgroundColor: Colors.black54,
                            child: IconButton(
                              icon: Icon(Icons.volume_up, color: Colors.white),
                              onPressed: () {
                                // Implement speaker functionality
                              },
                            ),
                          ),
                          // Video button
                          CircleAvatar(
                            backgroundColor: Colors.black54,
                            child: IconButton(
                              icon: Icon(Icons.videocam, color: Colors.white),
                              onPressed: () {
                                // Implement video toggle functionality
                              },
                            ),
                          ),
                          // Chat button
                          CircleAvatar(
                            backgroundColor: Colors.black54,
                            child: IconButton(
                              icon: Icon(Icons.chat, color: Colors.white),
                              onPressed: () {
                                // Implement chat functionality
                              },
                            ),
                          ),
                          // End call button
                          CircleAvatar(
                            backgroundColor: Colors.redAccent,
                            child: IconButton(
                              icon: Icon(Icons.call_end, color: Colors.white),
                              onPressed: () {
                                // Implement end call functionality
                              },
                            ),
                          ),
                        ],
                      ),
                    )
                  : Container();
            }),
          ],
        ),
      ),
    );
  }
}

// A StatefulWidget to manage dragging of the participant image
class DraggableParticipantImage extends StatefulWidget {
  @override
  _DraggableParticipantImageState createState() =>
      _DraggableParticipantImageState();
}

class _DraggableParticipantImageState extends State<DraggableParticipantImage> {
  Offset position =
      Offset(66.w, 50); // Initial position for the participant image

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: position.dx,
      top: position.dy,
      child: Draggable(
        feedback: _buildParticipantImage(), // The image while dragging
        childWhenDragging:
            Container(), // Hide the original widget while dragging
        onDraggableCanceled: (velocity, offset) {
          setState(() {
            position = offset; // Update the position after dragging ends
          });
        },
        child: _buildParticipantImage(), // The image in its normal state
      ),
    );
  }

  Widget _buildParticipantImage() {
    return Container(
      width: 100,
      height: 120,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.network(
          'https://www.shutterstock.com/shutterstock/videos/1058778940/thumb/7.jpg?ip=x480', // replace with participant's image URL
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
