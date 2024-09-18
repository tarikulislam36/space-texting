import 'package:get/get.dart';
import 'package:space_texting/app/routes/app_pages.dart';
import 'package:space_texting/constants/assets.dart';

class OnboardingController extends GetxController {
  //TODO: Implement OnboardingController

  final count = 0.obs;
  final List<String> onboardingImages = [
    Assets.assetsOnboarding2,
    Assets.assetsOnboarding3,
    Assets.assetsOnboarding4,
    Assets.assetsOnboarding5,
  ];

  final List<String> onboardingTexts = [
    "Take privacy with you.\nBe yourself in every message.",
    "Reach anyone in the world",
    "Groupchat, voicemail, send pics & more",
    "Emotion Recognition"
  ];
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

  void increment() {
    if (count.value == 3) {
      Get.toNamed(Routes.GET_STARTED);
      return;
    }
    count.value++;
  }
}
