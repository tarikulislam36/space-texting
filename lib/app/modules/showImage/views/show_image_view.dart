import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:image/image.dart';
import 'package:flutter/src/widgets/image.dart' as img;

import '../controllers/show_image_controller.dart';

class ShowImageView extends GetView<ShowImageController> {
  const ShowImageView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: img.Image.network(Get.arguments["img"])),
    );
  }
}
