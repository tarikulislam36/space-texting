import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:get/get.dart';
import 'package:glossy/glossy.dart';
import 'package:space_texting/app/components/custom_button.dart';
import 'package:space_texting/app/modules/welcome/views/welcome_dialog.dart';
import 'package:space_texting/app/services/responsive_size.dart';
import 'package:space_texting/constants/assets.dart';

import '../controllers/welcome_controller.dart';

class WelcomeView extends GetView<WelcomeController> {
  const WelcomeView({Key? key}) : super(key: key);
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
        () => Stack(
          children: [
            Align(
              alignment: Alignment.bottomCenter,
              child: GlossyContainer(
                height: 70.h,
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      30.kheightBox,
                      GlossyContainer(
                        height: 170,
                        width: 170,
                        opacity: 0.5,
                        strengthX: 0.3,
                        strengthY: 0.2,
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(40),
                        border: Border.all(color: Colors.black),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(18.0),
                            child: Image.asset(Assets.assetsLogo),
                          ),
                        ),
                      ),
                      10.kheightBox,
                      Text(
                        "Welcome to Space Texting \n& Calling",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 27.ksp,
                        ),
                      ),
                      28.kheightBox,
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Free messages and call - with end to end encryption",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 15.ksp,
                          ),
                        ),
                      ),
                      const Spacer(),
                      CustomElevatedButton(
                        height: 50,
                        width: 70.w,
                        buttonText: "Start now",
                        onPressed: controller.startNow,
                      ),
                      40.kheightBox,
                    ],
                  ),
                ),
              ),
            ),
            if (controller.isDialogShowing.value)
              Align(
                alignment: Alignment.center,
                child: Container(
                    height: 100.h,
                    width: 100.w,
                    decoration:
                        BoxDecoration(color: Colors.black.withOpacity(0.3)),
                    child: const WelcomeDialog()),
              )
          ],
        ),
      ),
    ));
  }
}
