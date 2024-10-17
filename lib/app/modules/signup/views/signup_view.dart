import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:glossy/glossy.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:space_texting/app/components/custom_button.dart';
import 'package:space_texting/app/modules/signup/controllers/signup_controller.dart';
import 'package:space_texting/app/services/responsive_size.dart';
import 'package:space_texting/constants/assets.dart';

class SignupView extends GetView<SignupController> {
  const SignupView({super.key});

  @override
  Widget build(BuildContext context) {
    // Create a PhoneNumber object with a default country

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
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Image.asset(
                  Assets.assetsSignup,
                  width: 50.w,
                ),
              ],
            ),
            GlossyContainer(
              height: 67.h,
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
                      10.kheightBox,
                      const Text(
                        "Welcome",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 40,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      10.kheightBox,
                      const Text(
                        "Enter your phone number to get started!",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      28.kheightBox,
                      // International Phone Number Input Field
                      InternationalPhoneNumberInput(
                        onInputChanged: controller.onPhoneNumberChanged,
                        onInputValidated: (bool value) {},
                        selectorTextStyle: const TextStyle(color: Colors.green),
                        selectorConfig: const SelectorConfig(
                          selectorType: PhoneInputSelectorType.DROPDOWN,
                        ),
                        initialValue: controller.phoneNumber,
                        textFieldController: controller.phoneController,
                        formatInput: true,
                        inputDecoration: InputDecoration(
                          labelText: 'Mobile Number',
                          labelStyle: const TextStyle(color: Colors.white70),
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.1),
                          hintText: '123456789',
                          hintStyle: const TextStyle(color: Colors.white70),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        textStyle: const TextStyle(color: Colors.white),
                      ),
                      const SizedBox(height: 20.0),
                      // Name Field

                      // Password Field

                      const Spacer(),
                      // Signup Button
                      CustomElevatedButton(
                        height: 50,
                        width: 100.w,
                        buttonText: "Sign up",
                        onPressed: controller.onSignupButtonPressed,
                      ),
                      20.kheightBox,
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
