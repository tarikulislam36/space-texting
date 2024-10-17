import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:space_texting/app/services/responsive_size.dart';
import 'package:space_texting/constants/assets.dart';

import '../controllers/profile_screen_controller.dart';

class ProfileScreenView extends GetView<ProfileScreenController> {
  const ProfileScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
        child: Column(
          children: [
            const SizedBox(height: 50), // Space for top margin
            // Profile Picture and Name
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  10.kwidthBox,
                  const CircleAvatar(
                    radius: 40,
                    backgroundImage: NetworkImage(
                        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRE4g-3ZH_1TjfN-zOuCRru2LrfrGtPbwaCsQ&s"),
                  ),
                  const SizedBox(width: 16),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Alice Space', // Replace with actual name
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  // QR code icon
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Menu Options
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: ListView(
                  children: [
                    _buildMenuItem(Icons.account_circle, 'Account',
                        'Privacy, security, change number'),
                    _buildMenuItem(
                        Icons.chat, 'Chat', 'Chat history, theme, wallpapers'),
                    _buildMenuItem(Icons.notifications, 'Notifications',
                        'Messages, group and others'),
                    _buildMenuItem(Icons.help, 'Help',
                        'Help center, contact us, privacy policy'),
                    _buildMenuItem(Icons.storage, 'Storage and data',
                        'Network usage, storage usage'),
                    _buildMenuItem(Icons.person_add, 'Invite a friend',
                        'invite friend to chat with him'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String title, String subtitle) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(
        title,
        style:
            const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(color: Colors.white.withOpacity(0.7)),
      ),
      onTap: () {
        // Implement navigation or action on tap
      },
    );
  }
}
