import 'package:get/get.dart';

import '../controllers/select_chat_controller.dart';

class SelectChatBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SelectChatController>(
      () => SelectChatController(),
    );
  }
}
