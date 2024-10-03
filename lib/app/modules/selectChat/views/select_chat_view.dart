import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:space_texting/app/services/responsive_size.dart';
import 'package:space_texting/constants/assets.dart';
import '../controllers/select_chat_controller.dart';

class SelectChatView extends GetView<SelectChatController> {
  const SelectChatView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text(
          "Select Contact",
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(
            Icons.arrow_back,
          ),
          color: Colors.white,
        ),
      ),
      body: Obx(() {
        // Check if contacts are empty
        if (controller.contacts.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        // Display list of contacts
        return Container(
          height: 100.h,
          width: 100.w,
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(
                    Assets.assetsBackground,
                  ),
                  fit: BoxFit.cover)),
          child: ListView.builder(
            itemCount: controller.contacts.length,
            itemBuilder: (context, index) {
              final contact = controller.contacts[index];

              return Padding(
                padding: const EdgeInsets.only(bottom: 6, top: 8),
                child: ListTile(
                  leading: const CircleAvatar(
                    backgroundImage:
                        AssetImage("assets/default_user.jpg"), // Default image
                    radius: 25,
                  ),
                  title: Text(
                    contact.displayName ?? 'No Name',
                    style: const TextStyle(color: Colors.white),
                  ), // Contact name
                  trailing: ElevatedButton(
                    onPressed: () {
                      // Invite action
                      controller.inviteContact(
                        contact.displayName ?? 'No Name',
                      );
                    },
                    child: const Text('Invite'),
                  ),
                ),
              );
            },
          ),
        );
      }),
    );
  }
}
