import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:space_texting/app/routes/app_pages.dart';

class AllowNotificationController extends GetxController {
  //TODO: Implement AllowNotificationController

  final count = 0.obs;
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

  Future<void> requestPermissions() async {
    // List of permissions to request
    Map<Permission, PermissionStatus> statuses = await [
      Permission.notification, // Notifications permission
      Permission.contacts, // Contacts permission
      Permission.storage, // Storage permission (Files)
      Permission.microphone, // Microphone permission
      Permission.camera, // Camera permission
      Permission.location, // Location permission
    ].request();

    Get.toNamed(Routes.NAVBAR);

    // Check the statuses of the permissions
    if (statuses[Permission.notification]!.isGranted) {
      print("Notification permission granted");
    } else {
      print("Notification permission denied");
    }

    if (statuses[Permission.contacts]!.isGranted) {
      print("Contacts permission granted");
    } else {
      print("Contacts permission denied");
    }

    if (statuses[Permission.storage]!.isGranted) {
      print("Files/Storage permission granted");
    } else {
      print("Files/Storage permission denied");
    }

    if (statuses[Permission.microphone]!.isGranted) {
      print("Microphone permission granted");
    } else {
      print("Microphone permission denied");
    }

    if (statuses[Permission.camera]!.isGranted) {
      print("Camera permission granted");
    } else {
      print("Camera permission denied");
    }

    if (statuses[Permission.location]!.isGranted) {
      print("Location permission granted");
    } else {
      print("Location permission denied");
    }
  }

  void increment() => count.value++;
}
