import 'dart:convert'; // Add this for jsonEncode
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import 'package:space_texting/app/services/date_format.dart';
import 'package:space_texting/app/services/endpoints.dart'; // Import the http package

class SelectChatController extends GetxController {
  var contacts = <Contact>[].obs; // Observable list of contacts
  var phoneContactMap =
      <String, Contact>{}.obs; // Observable map of phoneNumber -> Contact
  var userExistenceData =
      <UserData>[].obs; // Observable list for storing user existence data

  @override
  void onInit() async {
    super.onInit();
    await requestPermissionAndLoadContacts();
    // Request permission and load contacts
  }

  Future<void> requestPermissionAndLoadContacts() async {
    PermissionStatus permissionStatus = await Permission.contacts.status;

    if (permissionStatus.isGranted) {
      loadContacts(); // Load contacts if permission is granted
    } else if (permissionStatus.isDenied) {
      PermissionStatus newStatus = await Permission.contacts.request();
      if (newStatus.isGranted) {
        await loadContacts(); // Load contacts after permission is granted
      } else {
        Get.snackbar(
          'Permission Denied',
          'Contact permission is required to display contacts',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    }
  }

  Future<void> loadContacts() async {
    const defaultCountryCode = '+91'; // Set your default country code here

    try {
      final Iterable<Contact> deviceContacts =
          await ContactsService.getContacts();
      contacts.assignAll(deviceContacts);

      Map<String, Contact> phoneContactMapTemp =
          {}; // Temporary map to store phoneNumber -> Contact
      contacts.forEach((contact) {
        // Loop through each contact
        contact.phones?.forEach((phone) {
          // Loop through each phone number of the contact
          String formattedPhone =
              phone.value?.replaceAll(RegExp(r'[^+\d]'), '') ??
                  ""; // Keep only digits and the plus sign

          // Check if the phone number does not start with '+' (i.e., no country code)
          if (!formattedPhone.startsWith('+') && formattedPhone.isNotEmpty) {
            formattedPhone =
                '$defaultCountryCode$formattedPhone'; // Add default country code if missing
          }

          if (formattedPhone.isNotEmpty) {
            phoneContactMapTemp[formattedPhone] =
                contact; // Map phoneNumber to contact
          }
        });
      });

      phoneContactMap
          .assignAll(phoneContactMapTemp); // Assign the map to the observable
      print(phoneContactMap); // Print the phone number to contact map

      await checkPhoneNumbers(phoneContactMapTemp.keys
          .toList()); // Make API call after loading contacts
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load contacts: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // Method to check phone numbers against the API
  Future<void> checkPhoneNumbers(List<String> phoneNumbers) async {
    print(phoneNumbers);
    try {
      final response = await http.post(
        Uri.parse(ApiEndpoints.checkNumber), // Replace with your API endpoint
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'phoneNumbers': phoneNumbers}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == true) {
          // Map response data to user existence data list
          userExistenceData.assignAll(
            (data['data'] as List)
                .map((item) => UserData.fromJson(item))
                .toList(),
          );

          print(data['data']);
          print(userExistenceData); // Print the list of user existence data
        } else {
          Get.snackbar('Error', 'Failed to check phone numbers');
        }
      } else {
        Get.snackbar('Error', 'Failed to communicate with the server');
        print(response.body);
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred: $e');
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

// Model class for UserData
class UserData {
  final String phoneNumber;
  final bool exists;
  final User? user;

  UserData({
    required this.phoneNumber,
    required this.exists,
    this.user,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      phoneNumber: json['phoneNumber'],
      exists: json['exists'],
      user: json['user'] != null ? User.fromJson(json['user']) : null,
    );
  }
}

// Model class for User
class User {
  final String id;
  final String name;
  final String phoneNumber;
  final String status;
  final String profilePic;
  final String notificationToken;
  final DateTime createdAt;
  final String uid;

  User({
    required this.id,
    required this.name,
    required this.phoneNumber,
    required this.status,
    required this.profilePic,
    required this.notificationToken,
    required this.createdAt,
    required this.uid,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'] ?? '', // Default to empty string if null
      name: json['name'] ?? 'Unknown', // Default to 'Unknown' if null
      phoneNumber: json['phoneNumber'] ?? '', // Default to empty string if null
      status: json['status'] ?? 'inactive', // Default to 'inactive' if null
      profilePic: json['profilePic'] ?? '', // Default to empty string if null
      notificationToken:
          json['notificationToken'] ?? '', // Default to empty string if null
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      uid: json['uid'] ?? "", // Default to current date if null
    );
  }
}

// Model class for User
class UserHome {
  final String id;
  final String name;
  final String phoneNumber;
  final String status;
  final String profilePic;
  final String notificationToken;
  final Timestamp createdAt;
  final String uid;
  final bool isOnline;

  UserHome({
    required this.id,
    required this.name,
    required this.phoneNumber,
    required this.status,
    required this.profilePic,
    required this.notificationToken,
    required this.createdAt,
    required this.uid,
    required this.isOnline,
  });

  factory UserHome.fromJson(Map<String, dynamic> json) {
    return UserHome(
      id: json['_id'] ?? '', // Default to empty string if null
      name: json['name'] ?? 'Unknown', // Default to 'Unknown' if null
      phoneNumber: json['phoneNumber'] ?? '', // Default to empty string if null
      status: json['status'] ?? 'inactive', // Default to 'inactive' if null
      profilePic: json['profilePic'] ?? '', // Default to empty string if null
      notificationToken:
          json['notificationToken'] ?? '', // Default to empty string if null
      createdAt: json['createdAt'],
      isOnline: json["isOnline"] &&
              isRecentlyActive((json["lastSeen"] as Timestamp).toDate())
          ? true
          : false,
      uid: json['uid'] ?? "", // Default to current date if null
    );
  }
}
