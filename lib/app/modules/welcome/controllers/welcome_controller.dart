import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:glossy/glossy.dart';
import 'package:space_texting/app/modules/welcome/views/welcome_dialog.dart';
import 'package:space_texting/app/services/responsive_size.dart';

class WelcomeController extends GetxController {
  //TODO: Implement WelcomeController

  final count = 0.obs;
  final RxBool isDialogShowing = false.obs;
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void startNow() {
    isDialogShowing.value = true;
  }

  void startBack() {
    isDialogShowing.value = false;
  }

  void increment() => count.value++;
}
