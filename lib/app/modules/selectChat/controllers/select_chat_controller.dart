import 'package:get/get.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:permission_handler/permission_handler.dart';

class SelectChatController extends GetxController {
  // List of contacts as observable
  var contacts = <Contact>[].obs; // Store contacts from device

  @override
  void onInit() {
    super.onInit();
    requestPermissionAndLoadContacts(); // Request permission and load contacts
  }

  // Function to request permission and load contacts
  Future<void> requestPermissionAndLoadContacts() async {
    // Check if permission is already granted
    PermissionStatus permissionStatus = await Permission.contacts.status;

    if (permissionStatus.isGranted) {
      loadContacts(); // Load contacts if permission is granted
    } else if (permissionStatus.isDenied) {
      // Request permission
      PermissionStatus newStatus = await Permission.contacts.request();

      if (newStatus.isGranted) {
        loadContacts(); // Load contacts after permission is granted
      } else {
        Get.snackbar(
          'Permission Denied',
          'Contact permission is required to display contacts',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    }
  }

  // Function to load contacts from device
  Future<void> loadContacts() async {
    try {
      final Iterable<Contact> deviceContacts =
          await ContactsService.getContacts();
      contacts.assignAll(deviceContacts);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load contacts: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // Invite contact function
  void inviteContact(String name) {
    Get.snackbar(
      'Invite Sent',
      'Invitation sent to $name',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
