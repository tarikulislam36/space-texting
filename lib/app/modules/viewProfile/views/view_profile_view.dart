import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:space_texting/app/modules/chat/controllers/chat_controller.dart';
import 'package:space_texting/app/services/responsive_size.dart';
import 'package:space_texting/constants/assets.dart';
import '../controllers/view_profile_controller.dart';

class ViewProfileView extends GetView<ViewProfileController> {
  const ViewProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Profile",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.deepPurple,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("users")
              .doc(Get.arguments["targetUserId"])
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List AllChat = Get.find<ChatController>().messages;
              return Stack(
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
                          backgroundImage: snapshot.data!
                                  .data()!["profilePic"]
                                  .toString()
                                  .isEmpty
                              ? const AssetImage("assets/default_user.jpg")
                              : NetworkImage(snapshot.data!
                                  .data()!["profilePic"]
                                  .toString()) as ImageProvider<Object>,
                          radius: 60,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          snapshot.data!
                              .data()!["name"]
                              .toString(), // User name
                          style: const TextStyle(
                            fontSize: 22,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          snapshot.data!
                              .data()!["phoneNumber"]
                              .toString(), // Username or tag
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white54,
                          ),
                        ),
                        const SizedBox(height: 20),
                        // Action buttons (chat, video call, voice call, etc.)
                        Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      "Media",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  10.kheightBox,
                                  Wrap(
                                    children: [
                                      ...AllChat.map(
                                        (e) {
                                          print(e["type"]);
                                          return e["type"] == "photo"
                                              ? Image.network(
                                                  e["message"],
                                                  height: 200,
                                                  width: 180,
                                                  fit: BoxFit.cover,
                                                )
                                              : const SizedBox();
                                        },
                                      )
                                    ],
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // User details section (sliding container)
                ],
              );
            } else {
              return const CircularProgressIndicator();
            }
          }),
    );
  }
}
