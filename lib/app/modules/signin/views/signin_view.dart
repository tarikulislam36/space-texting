import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';
import 'package:glossy/glossy.dart';
import 'package:space_texting/app/components/custom_button.dart';
import 'package:space_texting/app/services/responsive_size.dart';
import 'package:space_texting/constants/assets.dart';

import '../controllers/signin_controller.dart';

class SigninView extends GetView<SigninController> {
  const SigninView({super.key});
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
              const Spacer(),
              Padding(
                padding: const EdgeInsets.only(right: 27),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Image.asset(
                      Assets.assetsLogin,
                      width: 65.w,
                    ),
                  ],
                ),
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
                          "Welcome Back!",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 40,
                              fontWeight: FontWeight.w600),
                        ),
                        30.kheightBox,
                        TextField(
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.1),
                            hintText: 'Phone number',
                            hintStyle: const TextStyle(color: Colors.white70),
                            prefixIcon:
                                const Icon(Icons.phone, color: Colors.white70),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          style: const TextStyle(color: Colors.white),
                        ),
                        const Spacer(),
                        CustomElevatedButton(
                          height: 50,
                          width: 100.w,
                          buttonText: "Sign in",
                          onPressed: () {},
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
