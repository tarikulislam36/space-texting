import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:glossy/glossy.dart';
import 'package:space_texting/app/components/custom_button.dart';
import 'package:space_texting/app/routes/app_pages.dart';
import 'package:space_texting/app/services/responsive_size.dart';
import 'package:space_texting/constants/assets.dart';
import '../controllers/get_started_controller.dart';

class GetStartedView extends GetView<GetStartedController> {
  const GetStartedView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: 100.h,
        width: 100.w,
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage(Assets.assetsBackground), fit: BoxFit.cover)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Spacer(),
            Image.asset(width: 90.w, Assets.assetsGetStarted),
            Spacer(),
            GlossyContainer(
              height: 38.h,
              width: 100.w,
              strengthY: 5,
              strengthX: 5,
              opacity: 0.5,
              color: const Color.fromARGB(255, 5, 1, 37),
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(38), topRight: Radius.circular(38)),
              border: const Border(top: BorderSide(color: Colors.white30)),
              child: SizedBox(
                width: 100.w,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    30.kheightBox,
                    const Text(
                      "Let’s connect in\none platform",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.w800),
                    ),
                    const Spacer(),
                    CustomElevatedButton(
                      height: 50,
                      width: 70.w,
                      buttonText: "Continue",
                      onPressed: () async {
                        bool isGranted =
                            await controller.requestNotificationPermission();
                        if (isGranted) {
                          Get.toNamed(Routes.SIGNUP);
                        } else {
                          // Show a message to the user
                          Get.snackbar(
                            "Permission Denied",
                            "Notifications permission is required to continue.",
                            snackPosition: SnackPosition.BOTTOM,
                          );
                        }
                      },
                    ),
                    40.kheightBox,
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
