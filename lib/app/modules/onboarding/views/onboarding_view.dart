import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:glossy/glossy.dart';
import 'package:space_texting/app/components/custom_button.dart';
import 'package:space_texting/app/services/responsive_size.dart';
import 'package:space_texting/constants/assets.dart';

import '../controllers/onboarding_controller.dart';

class OnboardingView extends GetView<OnboardingController> {
  const OnboardingView({Key? key}) : super(key: key);
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
      child: Obx(
        () => Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Spacer(),
            Image.asset(
                width: controller.count.value == 3 ? 100.w : 75.w,
                controller.onboardingImages[controller.count.value]),
            Spacer(),
            GlossyContainer(
              height: 45.h,
              width: 100.w,
              strengthY: 5,
              strengthX: 5,
              opacity: 0.5,
              color: const Color.fromARGB(255, 5, 1, 37),
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(38), topRight: Radius.circular(38)),
              border: const Border(top: BorderSide(color: Colors.white30)),
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: Column(
                  children: [
                    Text(
                      controller.onboardingTexts[controller.count.value],
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 34,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Spacer(),
                    Row(
                      children: [
                        const Text(
                          "Skip",
                          style: TextStyle(fontSize: 14, color: Colors.white54),
                        ),
                        const Spacer(),
                        CustomElevatedButton(
                          height: 45,
                          width: 30.w,
                          buttonText: "Next",
                          onPressed: controller.increment,
                        ),
                      ],
                    ),
                    20.kheightBox,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        for (int i = 0; i < 4; i++)
                          Container(
                            height: 5,
                            width: 5,
                            margin: const EdgeInsets.symmetric(
                              horizontal: 3,
                            ),
                            decoration: BoxDecoration(
                                color: controller.count.value == i
                                    ? Colors.white
                                    : Colors.white24,
                                borderRadius: BorderRadius.circular(2)),
                          )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
