import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart'; // Import Firebase Messaging
import 'package:http/http.dart' as http; // Import the http package
import 'dart:convert'; // Import for jsonEncode
import 'package:space_texting/app/routes/app_pages.dart';
import 'package:space_texting/app/services/endpoints.dart';
// Import your API endpoints

class SignupSuccessController extends GetxController {
  // Store the verification ID received from the previous screen
  late String verificationId;

  // Reactive variable for OTP input
  RxString otpInput = ''.obs;

  // Firebase Messaging instance
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  // Store notification token
  String? notificationToken;

  @override
  void onInit() {
    super.onInit();
    // Get the verification ID passed as an argument
    verificationId = Get.arguments['verificationId'];

    // Fetch the FCM notification token
    _getNotificationToken();
  }

  Future<void> _getNotificationToken() async {
    try {
      notificationToken = await _firebaseMessaging.getToken();
      if (notificationToken != null) {
        print('FCM Token: $notificationToken');
      } else {
        print('Failed to get FCM token');
      }
    } catch (e) {
      print('Error fetching FCM token: $e');
    }
  }

  // Method to verify the entered OTP
  Future<void> verifyOtp(String otp, String phoneNo) async {
    try {
      // Create a PhoneAuthCredential with the verification ID and OTP
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: otp,
      );

      // Sign in the user with the credential
      await FirebaseAuth.instance.signInWithCredential(credential);

      // Handle successful sign-in (e.g., navigate to the home screen)
      Get.snackbar('Success', 'OTP verified successfully!',
          backgroundColor: Colors.green, colorText: Colors.white);

      final firebaseToken =
          await FirebaseAuth.instance.currentUser?.getIdToken() ?? '';
      // final response =
      //     await _registerUser(phoneNo, notificationToken, firebaseToken);

      // if (response['status'] == true) {
      //   // Navigate to the Allow Notifications screen
      //   Get.offAllNamed(
      //     Routes.ALLOW_NOTIFICATION,
      //   );
      // } else {
      //   Get.snackbar('Error', response['message'],
      //       backgroundColor: Colors.red, colorText: Colors.white);
      // }
      Get.offAllNamed(
        Routes.ALLOW_NOTIFICATION,
      );
    } catch (e) {
      Get.snackbar('Error', '${e.toString()}',
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  // Function to register user with phone number and notification token
  Future<Map<String, dynamic>> _registerUser(String phoneNumber,
      String? notificationToken, String firebaseToken) async {
    final url = ApiEndpoints.register; // Your API URL
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $firebaseToken', // Add Bearer token here
        },
        body: jsonEncode({
          'phoneNumber': phoneNumber,
          'notificationToken': notificationToken,
        }),
      );

      if (response.statusCode == 201) {
        return jsonDecode(response.body); // Assuming the response is JSON
      } else {
        return {
          'status': false,
          'message': 'Failed to register user: ${response.reasonPhrase}',
        };
      }
    } catch (error) {
      return {
        'status': false,
        'message': 'Error: $error',
      };
    }
  }

  void setOtpInput(String otp) {
    otpInput.value = otp;
  }
}
