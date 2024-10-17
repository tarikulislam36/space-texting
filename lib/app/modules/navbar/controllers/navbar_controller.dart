import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';

class NavbarController extends GetxController {
  @override
  void onInit() async {
    super.onInit();

    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        print("message recived : $message");
      } else {
        print("print message null");
      }
    });
    print(
        "Auth token : ${await FirebaseAuth.instance.currentUser!.getIdToken()}");
    String? fcmToken = await FirebaseMessaging.instance.getToken();
    if (fcmToken != null) {
      print("FCM token: $fcmToken");
    } else {
      print("Failed to get FCM token");
    }
  }

  // To track the selected tab index
  var selectedIndex = 0.obs;

  // Example data for the badge (Unread message count)
  var unreadMessages = 0.obs;

  void onItemTapped(int index) {
    selectedIndex.value = index;
  }
}
