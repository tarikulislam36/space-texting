import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:space_texting/app/components/custom_button.dart';
import 'package:space_texting/app/routes/app_pages.dart';
import 'package:space_texting/app/services/responsive_size.dart';
import 'package:space_texting/constants/assets.dart';

import '../controllers/login_signup_controller.dart';

class LoginSignupView extends GetView<LoginSignupController> {
  const LoginSignupView({Key? key}) : super(key: key);
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
            40.kheightBox,
            Image.asset(width: 98.w, Assets.assetsLoginOrSignup),
            20.kheightBox,
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: [
                  Text(
                    "Claim your new\nphone number now",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                "Connect instantly with anyone, anywhere using your new phone number. Simple and reliable.",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.white),
              ),
            ),
            Spacer(),
            CustomElevatedButton(
              height: 50,
              width: 100.w - 60,
              buttonText: "Create a new account",
              onPressed: () {
                Get.toNamed(Routes.SIGNUP);
              },
            ),
            15.kheightBox,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Already have an account?",
                  style: TextStyle(color: Colors.white60),
                ),
                10.kwidthBox,
                InkWell(
                  onTap: () {
                    Get.toNamed(Routes.SIGNIN);
                  },
                  child: Text(
                    "Sign in",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
            30.kheightBox,
          ],
        ),
      ),
    );
  }
}
