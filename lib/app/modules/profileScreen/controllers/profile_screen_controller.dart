import 'package:get/get.dart';

class ProfileScreenController extends GetxController {
  //TODO: Implement ProfileScreenController

  final count = 0.obs;

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;

  // Assuming this state will be saved or retrieved from a persistent storage
  bool isNotificationsEnabled = false;

  @override
  void onInit() {
    super.onInit();
    // Load the notification setting from storage or API
    loadNotificationSetting();
  }

  void toggleNotifications(bool value) {
    isNotificationsEnabled = value;
    update(); // Notify the UI of the change

    // Save the new state (for example, in Firestore or SharedPreferences)
    saveNotificationSetting(value);
  }

  void loadNotificationSetting() {
    // Implement loading logic from Firestore, SharedPreferences, etc.
    // Example: isNotificationsEnabled = load from storage
    update();
  }

  void saveNotificationSetting(bool value) {
    // Implement saving logic to Firestore, SharedPreferences, etc.
  }
}
