import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:get/get.dart';
import 'package:space_texting/app/services/responsive_size.dart';
import '../controllers/video_call_controller.dart';

class VideoCallView extends GetView<VideoCallController> {
  const VideoCallView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          body: controller.isLoading.value
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : GestureDetector(
                  onTap: () {
                    // Show controls when the screen is tapped
                    controller.showControls();
                  },
                  child: Stack(
                    children: [
                      // Background network image (video placeholder)
                      Positioned.fill(
                        child: RTCVideoView(
                          controller.remoteVideoRenderer,
                          mirror: true,
                        ),
                      ),

                      // Top bar with back button

                      // Draggable small participant image
                      DraggableParticipantImage(
                          controller: controller), // Pass the controller

                      // Bottom control buttons (conditionally visible)
                      Obx(() {
                        return controller.showingControls.value
                            ? Positioned(
                                bottom: 40,
                                left: 0,
                                right: 0,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    // Mute button
                                    CircleAvatar(
                                      backgroundColor: controller.isMuted.value
                                          ? Colors.amber
                                          : Colors.black54,
                                      child: IconButton(
                                        icon: Icon(
                                            controller.isMuted.value
                                                ? Icons.mic_off_rounded
                                                : Icons.mic,
                                            color: Colors.white),
                                        onPressed: () {
                                          // Implement mute functionality
                                          controller.toggleMute();
                                        },
                                      ),
                                    ),
                                    // Speaker button
                                    CircleAvatar(
                                      backgroundColor:
                                          !controller.isSpeakerEnabled.value
                                              ? Colors.amber
                                              : Colors.black54,
                                      child: IconButton(
                                        icon: Icon(
                                            !controller.isSpeakerEnabled.value
                                                ? Icons.volume_off_rounded
                                                : Icons.volume_up,
                                            color: Colors.white),
                                        onPressed: () {
                                          // Implement speaker functionality
                                          controller.toggleSpeaker();
                                        },
                                      ),
                                    ),
                                    // Video button
                                    CircleAvatar(
                                      backgroundColor:
                                          !controller.isCameraOn.value
                                              ? Colors.amber
                                              : Colors.black54,
                                      child: IconButton(
                                        icon: Icon(
                                            !controller.isCameraOn.value
                                                ? Icons.videocam_off_rounded
                                                : Icons.videocam,
                                            color: Colors.white),
                                        onPressed: () {
                                          // Implement video toggle functionality
                                          controller.toggleCamera();
                                        },
                                      ),
                                    ),
                                    // Chat button
                                    CircleAvatar(
                                      backgroundColor: Colors.black54,
                                      child: IconButton(
                                        icon: const Icon(
                                            Icons.rotate_left_rounded,
                                            color: Colors.white),
                                        onPressed: () {
                                          // Implement chat functionality
                                          controller.rotateCamera();
                                        },
                                      ),
                                    ),
                                    // End call button
                                    CircleAvatar(
                                      backgroundColor: Colors.redAccent,
                                      child: IconButton(
                                        icon: Icon(Icons.call_end,
                                            color: Colors.white),
                                        onPressed: () {
                                          // Implement end call functionality
                                          controller.hangUp(
                                              controller.localVideoRenderer);
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
        ));
  }
}

// A StatefulWidget to manage dragging of the participant image
class DraggableParticipantImage extends StatefulWidget {
  final VideoCallController controller;

  const DraggableParticipantImage({Key? key, required this.controller})
      : super(key: key);

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
      width: 70,
      height: 120,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: RTCVideoView(
          widget.controller
              .localVideoRenderer, // Use the controller from the widget
          mirror: true,
        ),
      ),
    );
  }
}
