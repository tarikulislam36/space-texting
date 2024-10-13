import 'package:get/get.dart';
import 'package:space_texting/app/modules/chatScreen/controllers/chat_screen_controller.dart';

import '../controllers/navbar_controller.dart';

class NavbarBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NavbarController>(
      () => NavbarController(),
    );
    Get.lazyPut<ChatScreenController>(
      () => ChatScreenController(),
    );
  }
}
