import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:space_texting/app/components/custom_button.dart';
import 'package:space_texting/app/routes/app_pages.dart';
import 'package:space_texting/app/services/responsive_size.dart';
import 'package:space_texting/constants/assets.dart';
import '../controllers/get_user_details_controller.dart';
import 'dart:io';

class GetUserDetailsView extends GetView<GetUserDetailsController> {
  final ImagePicker _picker = ImagePicker();

  GetUserDetailsView({Key? key}) : super(key: key);

  Future<void> _pickImage(GetUserDetailsController controller) async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      controller.updateImage(File(pickedFile.path));
    }
  }

  Future<void> _pickDate(
      BuildContext context, GetUserDetailsController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Colors.deepPurple, // header color
              onPrimary: Colors.white, // text color
              surface: Colors.deepPurpleAccent, // background color
              onSurface: Colors.white, // date color
            ),
            dialogBackgroundColor: Colors.black,
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != controller.selectedDate.value) {
      controller.updateDateOfBirth(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<GetUserDetailsController>();

    return Scaffold(
      body: Container(
        height: 100.h,
        width: 100.w,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(Assets.assetsBackground),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Image Upload Section
                70.kheightBox,
                GestureDetector(
                  onTap: () => _pickImage(controller),
                  child: Obx(() => CircleAvatar(
                        backgroundColor: Colors.deepPurple.withOpacity(0.7),
                        radius: 80,
                        backgroundImage: controller.userImage.value != null
                            ? FileImage(controller.userImage.value!)
                            : const AssetImage('assets/default_avatar.png')
                                as ImageProvider,
                        child: controller.userImage.value == null
                            ? const Icon(Icons.add_a_photo,
                                size: 50, color: Colors.white)
                            : null,
                      )),
                ),
                const SizedBox(height: 50),

                // Name Input
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Enter your name',
                    labelStyle: const TextStyle(color: Colors.white),
                    filled: true,
                    fillColor: Colors.deepPurple.withOpacity(0.3),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                  style: const TextStyle(color: Colors.white), // White text
                  onChanged: (value) {
                    controller.updateName(value);
                  },
                ),
                const SizedBox(height: 20),

                // Gender Selection with ChoiceChip
                const Text(
                  "Select your gender:",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                const SizedBox(height: 10),
                Obx(() {
                  return Wrap(
                    spacing: 10,
                    alignment: WrapAlignment.center,
                    children: [
                      ChoiceChip(
                        label: const Text('Female'),
                        selected: controller.gender.value == 'Female',
                        onSelected: (bool selected) {
                          controller.updateGender('Female');
                        },
                        selectedColor: Colors.deepPurple,
                        backgroundColor: Colors.deepPurple.withOpacity(0.5),
                        labelStyle: TextStyle(
                          color: controller.gender.value == 'Female'
                              ? Colors.white
                              : Colors.white70,
                        ),
                      ),
                      ChoiceChip(
                        label: const Text('Male'),
                        selected: controller.gender.value == 'Male',
                        onSelected: (bool selected) {
                          controller.updateGender('Male');
                        },
                        selectedColor: Colors.deepPurple,
                        backgroundColor: Colors.deepPurple.withOpacity(0.5),
                        labelStyle: TextStyle(
                          color: controller.gender.value == 'Male'
                              ? Colors.white
                              : Colors.white70,
                        ),
                      ),
                      ChoiceChip(
                        label: const Text('Others'),
                        selected: controller.gender.value == 'Others',
                        onSelected: (bool selected) {
                          controller.updateGender('Others');
                        },
                        selectedColor: Colors.deepPurple,
                        backgroundColor: Colors.deepPurple.withOpacity(0.5),
                        labelStyle: TextStyle(
                          color: controller.gender.value == 'Others'
                              ? Colors.white
                              : Colors.white70,
                        ),
                      ),
                    ],
                  );
                }),
                const SizedBox(height: 30),

                // Date of Birth Selection
                GestureDetector(
                  onTap: () => _pickDate(context, controller),
                  child: Obx(() => Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 15),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white, width: 0.3),
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.deepPurple.withOpacity(0.3),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              controller.selectedDate.value == null
                                  ? 'Select your date of birth'
                                  : '${controller.selectedDate.value!.day}/${controller.selectedDate.value!.month}/${controller.selectedDate.value!.year}',
                              style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.white), // White text
                            ),
                            const Icon(Icons.calendar_today,
                                color: Colors.white),
                          ],
                        ),
                      )),
                ),
                const SizedBox(height: 30),

                // Continue Button
                50.kheightBox,
                CustomElevatedButton(
                  height: 46,
                  width: 80.w,
                  onPressed: () {
                    // if (controller.name.isNotEmpty &&
                    //     controller.gender.isNotEmpty &&
                    //     controller.selectedDate.value != null &&
                    //     controller.userImage.value != null) {
                    //   Get.snackbar("Success", "User details saved!",
                    //       snackPosition: SnackPosition.BOTTOM);
                    // } else {
                    //   Get.snackbar("Error", "Please fill in all fields!",
                    //       snackPosition: SnackPosition.BOTTOM);
                    // }

                    Get.toNamed(Routes.ALLOW_NOTIFICATION);
                  },
                  buttonText: "Continue",
                  buttonColor: Colors.deepPurple.withOpacity(0.8),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
