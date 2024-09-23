import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:space_texting/app/services/responsive_size.dart';
import 'package:space_texting/constants/assets.dart';
import '../controllers/view_profile_controller.dart';

class ViewProfileView extends GetView<ViewProfileController> {
  const ViewProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Container(
            height: 100.h,
            width: 100.w,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  Assets.assetsBackground,
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Profile content
          Positioned(
            top: 50, // Adjust top position as needed
            left: 0,
            right: 0,
            child: Column(
              children: [
                // Profile picture and name section
                CircleAvatar(
                  radius: 50, // Profile picture size
                  backgroundImage: NetworkImage(
                      'https://www.shutterstock.com/shutterstock/videos/1058778940/thumb/7.jpg?ip=x480'), // Replace with the actual path of the profile image
                ),
                const SizedBox(height: 10),
                const Text(
                  'John Abraham', // User name
                  style: TextStyle(
                    fontSize: 22,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  '@Name', // Username or tag
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white54,
                  ),
                ),
                const SizedBox(height: 20),
                // Action buttons (chat, video call, voice call, etc.)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Icon(Icons.message, color: Colors.white),
                      onPressed: () {
                        // Chat action
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.videocam, color: Colors.white),
                      onPressed: () {
                        // Video call action
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.call, color: Colors.white),
                      onPressed: () {
                        // Voice call action
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.more_horiz, color: Colors.white),
                      onPressed: () {
                        // More options action
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          // User details section (sliding container)
          Positioned(
            bottom: 0, // Adjust top position for the sliding details container
            left: 0,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xFF1E0E2F)
                    .withOpacity(0.7), // Dark purple background color
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.white54,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Display Name',
                    style: TextStyle(
                      color: Colors.white54,
                      fontSize: 14,
                    ),
                  ),
                  const Text(
                    'John Abraham', // Replace with user's display name
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Email Address',
                    style: TextStyle(
                      color: Colors.white54,
                      fontSize: 14,
                    ),
                  ),
                  const Text(
                    'email@gmail.com', // Replace with user's email address
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Address',
                    style: TextStyle(
                      color: Colors.white54,
                      fontSize: 14,
                    ),
                  ),
                  const Text(
                    'Location', // Replace with user's address
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Phone Number',
                    style: TextStyle(
                      color: Colors.white54,
                      fontSize: 14,
                    ),
                  ),
                  const Text(
                    '123456789', // Replace with user's phone number
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Media shared section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Media Shared',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          // Navigate to view all media shared
                        },
                        child: const Text(
                          'View All',
                          style: TextStyle(
                            color: Colors.tealAccent,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  // Media images (for illustration)
                  Row(
                    children: [
                      // Replace with actual media images
                      Image.network(
                        'https://via.placeholder.com/60', // Example media
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                      ),
                      const SizedBox(width: 10),
                      Image.network(
                        'https://via.placeholder.com/60', // Example media
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                      ),
                      const SizedBox(width: 10),
                      Image.network(
                        'https://via.placeholder.com/60', // Example media
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
