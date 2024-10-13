import 'package:get/get.dart';

import '../controllers/show_image_controller.dart';

class ShowImageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ShowImageController>(
      () => ShowImageController(),
    );
  }
}
