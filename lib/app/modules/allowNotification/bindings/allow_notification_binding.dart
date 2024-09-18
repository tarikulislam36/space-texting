import 'package:get/get.dart';

import '../controllers/allow_notification_controller.dart';

class AllowNotificationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AllowNotificationController>(
      () => AllowNotificationController(),
    );
  }
}
