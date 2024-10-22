import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:space_texting/app/components/custom_button.dart';
import 'package:space_texting/app/services/responsive_size.dart';
import 'package:space_texting/constants/assets.dart';

import '../controllers/edit_profile_controller.dart';

class EditProfileView extends GetView<EditProfileController> {
  const EditProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
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
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              20.kheightBox,
              Center(
                child: GetBuilder<EditProfileController>(
                  builder: (controller) => Stack(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: controller.selectedImage != null
                            ? FileImage(controller.selectedImage!)
                            : controller.profilePicUrl.isNotEmpty
                                ? NetworkImage(controller.profilePicUrl.value)
                                    as ImageProvider
                                : const AssetImage('assets/default_user.jpg'),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: IconButton(
                          icon: const Icon(Icons.camera_alt),
                          onPressed: () => controller.pickImage(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 40),
              GetBuilder<EditProfileController>(
                builder: (controller) => TextField(
                  controller:
                      TextEditingController(text: controller.name.value),
                  onChanged: (value) => controller.name.value = value,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'Name',
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                  ),
                ),
              ),
              const SizedBox(height: 90),
              CustomElevatedButton(
                buttonText: "Submit",
                height: 45,
                onPressed: () {
                  controller.updateProfile(
                    controller.name.value,
                    controller.selectedImage,
                  );
                },
                width: 100.w,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
