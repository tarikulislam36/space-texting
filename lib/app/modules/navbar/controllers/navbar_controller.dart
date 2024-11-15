import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:space_texting/app/modules/chatScreen/controllers/chat_screen_controller.dart';

class NavbarController extends GetxController {
  Timer? _onlineStatusTimer;

  @override
  void onInit() async {
    super.onInit();
    _setOnlineStatus();

    print(
        "Auth token : ${await FirebaseAuth.instance.currentUser!.getIdToken()}");
    String? fcmToken = await FirebaseMessaging.instance.getToken();
    if (fcmToken != null) {
      print("FCM token: $fcmToken");
    } else {
      print("Failed to get FCM token");
    }

    // Start the timer to set online status every 4 minutes
    _onlineStatusTimer = Timer.periodic(Duration(minutes: 4), (timer) {
      _setOnlineStatus();
    });
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> _setOnlineStatus() async {
    print("Online status called");
    final user = _auth.currentUser;
    if (user != null) {
      await _firestore.collection('users').doc(user.uid).update({
        'isOnline': true,
        'lastSeen': FieldValue.serverTimestamp(),
      });
      print("Online");
    }
  }

  Future<void> _setOfflineStatus() async {
    print("Offline status called");
    final user = _auth.currentUser;
    if (user != null) {
      await _firestore.collection('users').doc(user.uid).update({
        'isOnline': false,
        'lastSeen': FieldValue.serverTimestamp(),
      });
    }
  }

  // To track the selected tab index
  var selectedIndex = 0.obs;

  // Example data for the badge (Unread message count)
  var unreadMessages = 0.obs;

  void onItemTapped(int index) {
    selectedIndex.value = index;
  }

  @override
  void onClose() {
    // Cancel the timer to prevent memory leaks
    _onlineStatusTimer?.cancel();
    super.onClose();
  }
}
