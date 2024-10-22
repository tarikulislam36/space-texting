import 'package:android_intent_plus/android_intent.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:space_texting/app/routes/app_pages.dart';
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
            SizedBox(height: 10.h), // Space for top margin
            // Profile Picture and Name
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("users")
                      .doc(FirebaseAuth.instance.currentUser!.uid)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Column(
                        children: [
                          10.kwidthBox,
                          CircleAvatar(
                            radius: 40,
                            backgroundImage: snapshot.data!
                                    .data()!["profilePic"]
                                    .toString()
                                    .isEmpty
                                ? const AssetImage("assets/default_user.jpg")
                                    as ImageProvider
                                : NetworkImage(
                                    snapshot.data!.data()!["profilePic"]),
                          ),
                          const SizedBox(height: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                snapshot.data!
                                        .data()!["name"]
                                        .toString()
                                        .isEmpty
                                    ? snapshot.data!.data()!["phoneNumber"]
                                    : snapshot.data!
                                        .data()!["name"]
                                        .toString(), // Replace with actual name
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          // QR code icon
                        ],
                      );
                    }

                    return const SizedBox();
                  }),
            ),

            // Menu Options
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: ListView(
                  children: [
                    _buildMenuItem(Icons.account_circle, 'Edit Account',
                        'Privacy, security, change number', () {
                      Get.toNamed(Routes.EDIT_PROFILE);
                    }),
                    _buildMenuItem(Icons.notifications, 'Notifications',
                        'Manage app notifications', () {
                      _openNotificationSettings();
                    }),
                    _buildMenuItem(Icons.person_add, 'Invite a friend',
                        'Invite friend to chat with them', () {}),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(
      IconData icon, String title, String subtitle, Function onTap) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListTile(
        leading: Icon(
          icon,
          color: Colors.white,
          size: 30,
        ),
        title: Text(
          title,
          style:
              const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        onTap: () {
          onTap();
        },
      ),
    );
  }

  // Method to open the notification settings of the app
  void _openNotificationSettings() async {
    final intent = AndroidIntent(
      action: 'android.settings.APP_NOTIFICATION_SETTINGS',
      arguments: {
        'android.provider.extra.APP_PACKAGE':
            'com.your.package.name', // Replace with your package name
      },
    );
    await intent.launch();
  }
}
