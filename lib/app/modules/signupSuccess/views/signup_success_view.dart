import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:glossy/glossy.dart';
import 'package:pinput/pinput.dart';
import 'package:space_texting/app/components/custom_button.dart';
import 'package:space_texting/app/routes/app_pages.dart';
import 'package:space_texting/app/services/responsive_size.dart';
import 'package:space_texting/constants/assets.dart';

import '../controllers/signup_success_controller.dart';

class SignupSuccessView extends GetView<SignupSuccessController> {
  const SignupSuccessView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
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
              Row(
                children: [
                  18.kwidthBox,
                  IconButton(
                      onPressed: () {
                        Get.back();
                      },
                      icon: SvgPicture.asset(Assets.assetsBackIcon))
                ],
              ),
              Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Image.asset(
                    Assets.assetsLogin,
                    width: 65.w,
                  ),
                ],
              ),
              GlossyContainer(
                height: 60.h,
                width: 100.w,
                strengthY: 5,
                strengthX: 5,
                opacity: 0.5,
                color: const Color.fromARGB(255, 5, 1, 37),
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(38),
                    topRight: Radius.circular(38)),
                border: const Border(top: BorderSide(color: Colors.white30)),
                child: SizedBox(
                  width: 100.w,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        10.kheightBox,
                        const Text(
                          "Verification Code",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 36,
                              fontWeight: FontWeight.w600),
                        ),
                        30.kheightBox,
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            "We have sand OTP code verification to your mobile no",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white54,
                                fontSize: 16,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        10.kheightBox,
                        Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 0.0, horizontal: 20.0),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '+91 123456789', // Replace with actual phone number
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  // Handle edit action here
                                },
                                icon: Icon(
                                  Icons.edit,
                                  color: Colors.pinkAccent,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                            height:
                                40), // Spacing between phone number and OTP input
                        Pinput(
                          length: 4, // Set the length of the OTP
                          defaultPinTheme: PinTheme(
                            width: 60,
                            height: 60,
                            textStyle: TextStyle(
                              fontSize: 24,
                              color: Colors.white,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                        ),
                        Spacer(),
                        CustomElevatedButton(
                          height: 50,
                          width: 100.w,
                          buttonText: "Submit",
                          onPressed: () {
                            Get.toNamed(Routes.GET_USER_DETAILS);
                          },
                        ),
                        40.kheightBox,
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
