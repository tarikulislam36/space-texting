import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:space_texting/app/modules/chat/views/chat_view.dart';
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
          child: ListView(
            children: [
              ...controller.userExistenceData.map((element) => element.exists
                  ? InkWell(
                      onTap: () {
                        Get.off(() => ChatView(
                              name: controller
                                      .phoneContactMap[element.phoneNumber]
                                      ?.displayName ??
                                  element.phoneNumber,
                              profileImage: "",
                              targetUserId: element.user!.uid,
                              userId: FirebaseAuth.instance.currentUser!.uid,
                            ));
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 6, top: 10),
                        child: ListTile(
                          leading: const CircleAvatar(
                            backgroundImage: AssetImage(
                                "assets/default_user.jpg"), // Default image
                            radius: 25,
                          ),
                          title: Text(
                            element.exists
                                ? controller
                                        .phoneContactMap[element.phoneNumber]
                                        ?.displayName ??
                                    element.phoneNumber
                                : "No Name",
                            style: const TextStyle(color: Colors.white),
                          ),
                          // Contact name
                        ),
                      ),
                    )
                  : const SizedBox()),
              ...controller.userExistenceData.map((element) => !element.exists
                  ? InkWell(
                      onTap: () {},
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 6, top: 10),
                        child: ListTile(
                          leading: const CircleAvatar(
                            backgroundImage: AssetImage(
                                "assets/default_user.jpg"), // Default image
                            radius: 25,
                          ),
                          title: Text(
                            controller.phoneContactMap[element.phoneNumber]
                                    ?.displayName ??
                                element.phoneNumber,
                            style: const TextStyle(color: Colors.white),
                          ),
                          trailing: ElevatedButton(
                            onPressed: () {
                              Share.share(
                                  'check out my App https://example.com');
                            },
                            child: const Text("Invite"),
                          ),
                          // Contact name
                        ),
                      ),
                    )
                  : const SizedBox()),
            ],
          ),
        );
      }),
    );
  }
}
