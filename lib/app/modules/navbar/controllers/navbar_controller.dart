import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class NavbarController extends GetxController {
  @override
  void onInit() async {
    super.onInit();
    print(
        "Auth token : ${await FirebaseAuth.instance.currentUser!.getIdToken()}");
  }

  // To track the selected tab index
  var selectedIndex = 1.obs;

  // Example data for the badge (Unread message count)
  var unreadMessages = 2.obs;

  void onItemTapped(int index) {
    selectedIndex.value = index;
  }
}
