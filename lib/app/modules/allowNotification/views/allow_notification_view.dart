import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:space_texting/app/components/custom_button.dart';
import 'package:space_texting/app/services/responsive_size.dart';
import 'package:space_texting/constants/assets.dart';

import '../controllers/allow_notification_controller.dart';

class AllowNotificationView extends GetView<AllowNotificationController> {
  const AllowNotificationView({Key? key}) : super(key: key);
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
                fit: BoxFit.cover)),
        child: Column(
          children: [
            100.kheightBox,
            const Text(
              "Allow Permissions",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 34,
                  fontWeight: FontWeight.w600),
            ),
            const Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "Allowing notifications and contacts lets you see when messages arrive and helps you find people you know. Contacts are encrypted so the Signal service can't see them.",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500),
              ),
            ),
            20.kheightBox,
            Image.asset(
              Assets.assetsAllowPermissions,
              width: 70.w,
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: CustomElevatedButton(
                height: 50,
                width: 100.w,
                buttonText: "Allow Permissions",
                onPressed: controller.requestPermissions,
              ),
            ),
            40.kheightBox,
          ],
        ),
      ),
    );
  }
}
