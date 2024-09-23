import 'package:get/get.dart';

import '../controllers/voice_call_controller.dart';

class VoiceCallBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<VoiceCallController>(
      () => VoiceCallController(),
    );
  }
}
