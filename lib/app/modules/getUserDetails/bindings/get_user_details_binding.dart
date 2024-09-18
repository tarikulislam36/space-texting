import 'package:get/get.dart';

import '../controllers/get_user_details_controller.dart';

class GetUserDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<GetUserDetailsController>(
      () => GetUserDetailsController(),
    );
  }
}
