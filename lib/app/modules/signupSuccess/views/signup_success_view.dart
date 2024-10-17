import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:glossy/glossy.dart';
import 'package:pinput/pinput.dart';
import 'package:space_texting/app/components/custom_button.dart';
import 'package:space_texting/app/routes/app_pages.dart';
import 'package:space_texting/app/services/dialog_helper.dart';
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
            fit: BoxFit.cover,
          ),
        ),
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
                  icon: SvgPicture.asset(Assets.assetsBackIcon),
                ),
              ],
            ),
            Spacer(),
            Padding(
              padding: const EdgeInsets.only(right: 28),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Image.asset(
                    Assets.assetsLogin,
                    width: 50.w,
                  ),
                ],
              ),
            ),
            GlossyContainer(
              height: 68.h,
              width: 100.w,
              strengthY: 5,
              strengthX: 5,
              opacity: 0.5,
              color: const Color.fromARGB(255, 5, 1, 37),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(38),
                topRight: Radius.circular(38),
              ),
              border: const Border(top: BorderSide(color: Colors.white30)),
              child: SizedBox(
                width: 100.w,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      1.kheightBox,
                      const Text(
                        "Verification Code",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 36,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      10.kheightBox,
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          "We have sent an OTP code verification to your mobile number.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white54,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      // Spacing between phone number and OTP input
                      Pinput(
                        length: 6, // Set the length of the OTP
                        onChanged: (value) {
                          controller.setOtpInput(value);
                        },
                        defaultPinTheme: PinTheme(
                          width: 50,
                          height: 50,
                          textStyle: const TextStyle(
                            fontSize: 24,
                            color: Colors.white,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ),
                      10.kheightBox,
                      Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 0.0, horizontal: 20.0),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${Get.arguments["phoneNo"]}', // Display phone number
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                // Handle edit action here
                                Get.back();
                              },
                              icon: const Icon(
                                Icons.edit,
                                color: Colors.pinkAccent,
                              ),
                            ),
                          ],
                        ),
                      ),

                      Spacer(),
                      CustomElevatedButton(
                        height: 50,
                        width: 100.w,
                        buttonText: "Submit",
                        onPressed: () async {
                          // Show loading dialog
                          String phoneNo = Get.arguments["phoneNo"];
                          DialogHelper.showLoading();
                          print(phoneNo);

                          // Get the OTP from the controller
                          String otp = controller.otpInput.value;

                          // Verify the OTP
                          await controller.verifyOtp(otp, phoneNo);

                          // Hide loading dialog after verification
                          DialogHelper.hideDialog();
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
      ),
    );
  }
}
