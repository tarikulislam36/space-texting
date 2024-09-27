import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:space_texting/app/routes/app_pages.dart';

class SignupSuccessController extends GetxController {
  // Store the verification ID received from the previous screen
  late String verificationId;

  // Reactive variable for OTP input
  RxString otpInput = ''.obs;

  @override
  void onInit() {
    super.onInit();
    // Get the verification ID passed as an argument
    verificationId = Get.arguments['verificationId'];
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  // Method to verify the entered OTP
  Future<void> verifyOtp(String otp) async {
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
      Get.offAllNamed(
        Routes.ALLOW_NOTIFICATION,
      ); // Navigate to the home screen
    } catch (e) {
      Get.snackbar('Error', 'Invalid OTP, please try again.',
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  void setOtpInput(String otp) {
    otpInput.value = otp;
  }
}
