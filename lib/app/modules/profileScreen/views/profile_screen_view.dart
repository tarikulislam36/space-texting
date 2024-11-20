import 'package:android_intent_plus/android_intent.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:space_texting/app/routes/app_pages.dart';
import 'package:space_texting/app/services/database_helper.dart';
import 'package:space_texting/app/services/responsive_size.dart';
import 'package:space_texting/app/services/stripe_payment.dart';
import 'package:space_texting/constants/assets.dart';
import 'package:url_launcher/url_launcher.dart';
import '../controllers/profile_screen_controller.dart';

class ProfileScreenView extends GetView<ProfileScreenController> {
  const ProfileScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    DatabaseHelper dbHelper = DatabaseHelper();
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
            SizedBox(height: 5.h), // Space for top margin
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
                            crossAxisAlignment: CrossAxisAlignment.center,
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
                              Text(
                                snapshot.data!
                                        .data()!["name"]
                                        .toString()
                                        .isNotEmpty
                                    ? snapshot.data!.data()!["phoneNumber"]
                                    : "", // Replace with actual name
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
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
                    _buildMenuItem(Icons.card_membership_rounded, 'Membership',
                        'Manage app notifications', () {
                      _showConfirmationDialog(
                        context,
                        'Membership',
                        'Membership will cost you \$6.99/months',
                        () async {
                          print("click");
                          StripePaymentService().processPayment("6.99", "USD");
                        },
                      );
                    }),
                    _buildMenuItem(Icons.person_add, 'Invite a friend',
                        'Invite friend to chat with them', () {
                      Share.share(
                          'Checkout my app space texting and calling use the link to download : https://www.youtube.com/watch?v=dQw4w9WgXcQ');
                    }),
                    _buildMenuItem(Icons.privacy_tip, 'Privacy Policy',
                        'Manage app notifications', () async {
                      await launchUrl(
                          Uri.parse("https://spacetexting.com/policy"));
                    }),
                    _buildMenuItem(Icons.logout, 'Logout',
                        'Invite friend to chat with them', () {
                      _showConfirmationDialog(
                        context,
                        'Logout',
                        'Are you sure you want to log out? All local data will be lost.',
                        () async {
                          // Sign out from Firebase
                          await FirebaseAuth.instance.signOut();

                          // Navigate to the login screen or landing page if necessary
                          dbHelper.clearAllData();
                          Get.offAllNamed(Routes.SIGNUP);
                        },
                      );
                    }),
                    _buildMenuItem(Icons.delete, 'Delete Account',
                        'Invite friend to chat with them', () {
                      _showConfirmationDialog(
                        context,
                        'Delete Account',
                        'Are you sure you want to delete your account? This action cannot be undone, and all data will be permanently lost.',
                        () async {
                          try {
                            // Clear local data
                            await dbHelper.clearAllData();

                            // Delete the Firebase user account
                            await FirebaseAuth.instance.currentUser?.delete();

                            // Optionally, navigate to the login or sign-up screen
                            Get.offAllNamed(Routes.SPLASH);
                          } catch (e) {
                            if (e is FirebaseAuthException &&
                                e.code == 'requires-recent-login') {
                              // If reauthentication is needed
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        'Please reauthenticate to delete your account.')),
                              );
                            } else {
                              // Handle other errors
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text(
                                        'Failed to delete account: ${e.toString()}')),
                              );
                            }
                          }
                        },
                      );
                    }),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showConfirmationDialog(BuildContext context, String title,
      String message, VoidCallback onConfirm) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.deepPurple,
          title: Text(title),
          content: Text(message),
          titleTextStyle: const TextStyle(color: Colors.white, fontSize: 18),
          contentTextStyle: const TextStyle(color: Colors.white, fontSize: 14),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(), // Close the dialog
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.white),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                onConfirm(); // Proceed with the action
              },
              child: const Text(
                'Confirm',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
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
    const intent = AndroidIntent(
      action: 'android.settings.APP_NOTIFICATION_SETTINGS',
      arguments: {
        'android.provider.extra.APP_PACKAGE':
            'com.joy.space_texting', // Replace with your package name
      },
    );
    await intent.launch();
  }
}
