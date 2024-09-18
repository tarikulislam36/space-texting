import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:glossy/glossy.dart';
import 'package:space_texting/app/components/custom_button.dart';
import 'package:space_texting/app/routes/app_pages.dart';
import 'package:space_texting/app/services/responsive_size.dart';
import 'package:space_texting/constants/assets.dart';

import '../controllers/signup_controller.dart';

class SignupView extends GetView<SignupController> {
  const SignupView({Key? key}) : super(key: key);
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
                    Assets.assetsSignup,
                    width: 56.w,
                  ),
                ],
              ),
              GlossyContainer(
                height: 63.h,
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
                          "Get Started",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 40,
                              fontWeight: FontWeight.w600),
                        ),
                        20.kheightBox,
                        TextField(
                          // controller: mobileController,
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            labelText: 'Mobile Number',
                            labelStyle: TextStyle(color: Colors.white70),
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.1),
                            hintText: '123456789',
                            hintStyle: TextStyle(color: Colors.white70),
                            prefixIcon: Container(
                              padding: EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Image.asset(
                                    Assets
                                        .assetsIndianFlag, // Replace with your flag image path
                                    width: 24,
                                  ),
                                  SizedBox(width: 8.0),
                                  Text(
                                    '+91',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  Icon(Icons.arrow_drop_down,
                                      color: Colors.white70),
                                ],
                              ),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          style: TextStyle(color: Colors.white),
                        ),
                        SizedBox(height: 20.0),
                        // Name Field
                        TextField(
                          // controller: nameController,
                          decoration: InputDecoration(
                            labelText: 'Your Name',
                            labelStyle: TextStyle(color: Colors.white70),
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.1),
                            hintText: '@yourname',
                            hintStyle: TextStyle(color: Colors.white70),
                            prefixIcon:
                                Icon(Icons.person, color: Colors.white70),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          style: TextStyle(color: Colors.white),
                        ),
                        SizedBox(height: 20.0),
                        // Password Field
                        TextField(
                          // controller: passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            labelStyle: TextStyle(color: Colors.white70),
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.1),
                            hintText: 'Password',
                            hintStyle: TextStyle(color: Colors.white70),
                            prefixIcon:
                                Icon(Icons.vpn_key, color: Colors.white70),
                            suffixIcon: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.check, color: Colors.green),
                                SizedBox(width: 4),
                                Text('Strong',
                                    style: TextStyle(color: Colors.green)),
                                SizedBox(
                                    width:
                                        12), // Adjust the spacing to align with padding
                              ],
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          style: TextStyle(color: Colors.white),
                        ),
                        Spacer(),
                        CustomElevatedButton(
                          height: 50,
                          width: 100.w,
                          buttonText: "Sign up",
                          onPressed: () {
                            Get.toNamed(Routes.SIGNUP_SUCCESS);
                          },
                        ),
                        20.kheightBox,
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
