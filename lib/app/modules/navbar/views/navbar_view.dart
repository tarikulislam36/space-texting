import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:space_texting/app/modules/chatScreen/views/chat_screen_view.dart';
import 'package:space_texting/app/modules/profileScreen/views/profile_screen_view.dart';
import '../controllers/navbar_controller.dart';

class NavbarView extends GetView<NavbarController> {
  const NavbarView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        switch (controller.selectedIndex.value) {
          case 0:
            return const ChatScreenView();
          case 1:
            return const ProfileScreenView();
          default:
            return const Center(child: Text('NavbarView is working'));
        }
      }),
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30.0),
          topRight: Radius.circular(30.0),
        ), // Only curve the top corners
        child: Obx(
          () => BottomNavigationBar(
            currentIndex: controller.selectedIndex.value,
            onTap: controller.onItemTapped,
            backgroundColor:
                const Color(0xFF7A6FEC), // Set to the color you want
            selectedItemColor: Colors.black,
            unselectedItemColor: Colors.black38,
            showSelectedLabels: true,
            showUnselectedLabels: true,
            type: BottomNavigationBarType.fixed,
            items: [
              BottomNavigationBarItem(
                icon: Stack(
                  children: [
                    const Icon(Icons.chat_bubble_outline, size: 30),
                    if (controller.unreadMessages.value > 0)
                      Positioned(
                        right: 0,
                        child: CircleAvatar(
                          radius: 8,
                          backgroundColor: Colors.green,
                          child: Text(
                            '${controller.unreadMessages.value}',
                            style: const TextStyle(
                              fontSize: 10,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                label: 'Chats',
              ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.person_outline, size: 30),
                label: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
