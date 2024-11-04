import 'package:get/get.dart';
import 'package:space_texting/app/routes/app_pages.dart';
import 'package:space_texting/app/services/database_helper.dart';

class SplashController extends GetxController {
  //TODO: Implement SplashController

  double opacity = 0.5;
  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
    DatabaseHelper db = DatabaseHelper();
    Future.delayed(
      const Duration(seconds: 1),
      () {
        Get.toNamed(Routes.WELCOME);
      },
    );
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;
}
