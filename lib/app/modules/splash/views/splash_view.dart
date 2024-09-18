import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:glossy/glossy.dart';
import 'package:space_texting/app/services/responsive_size.dart';
import 'package:space_texting/constants/assets.dart';

import '../controllers/splash_controller.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        height: 100.h,
        width: 100.w,
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage(
                  Assets.assetsBackground,
                ),
                fit: BoxFit.cover)),
        child: Center(
          child: GlossyContainer(
            height: 170,
            width: 170,
            opacity: controller.opacity,
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
        ),
      ),
    );
  }
}
