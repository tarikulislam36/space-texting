import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:space_texting/app/routes/app_pages.dart';
import 'package:space_texting/app/services/dialog_helper.dart';

class SignupController extends GetxController {
  // Controllers for input fields
  TextEditingController phoneController = TextEditingController();

  // Variables to hold the selected phone number and validation states
  PhoneNumber phoneNumber = PhoneNumber(isoCode: 'IN');
  RxBool isPhoneNumberValid = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Initialize controllers with validation listeners
    phoneController.addListener(_validatePhoneNumber);
  }

  void _validatePhoneNumber() async {
    String number = phoneController.text.trim();
    if (number.isEmpty) {
      isPhoneNumberValid.value = false;
      return;
    }

    try {
      PhoneNumber parsedNumber = await PhoneNumber.getRegionInfoFromPhoneNumber(
          number, phoneNumber.isoCode!);
      isPhoneNumberValid.value = parsedNumber.phoneNumber != null &&
          parsedNumber.phoneNumber!.isNotEmpty;
    } catch (e) {
      isPhoneNumberValid.value = false;
    }
  }

  void onPhoneNumberChanged(PhoneNumber number) {
    phoneNumber = number;
    _validatePhoneNumber();
  }

  Future<void> onSignupButtonPressed() async {
    if (isPhoneNumberValid.value) {
      // Show loading dialog
      DialogHelper.showLoading();

      // Get the complete phone number with country code
      String completePhoneNumber = phoneNumber.phoneNumber ?? '';
      print("Validated Phone Number: $completePhoneNumber");

      try {
        // Send OTP to the phone number
        await FirebaseAuth.instance.verifyPhoneNumber(
          phoneNumber: completePhoneNumber,
          verificationCompleted: (PhoneAuthCredential credential) async {
            // Auto-retrieval or instant verification
            await FirebaseAuth.instance.signInWithCredential(credential);
            DialogHelper.hideDialog();
            Get.snackbar('Success', 'Phone number automatically verified!',
                backgroundColor: Colors.green, colorText: Colors.white);
          },
          verificationFailed: (FirebaseAuthException e) {
            DialogHelper.hideDialog();
            Get.snackbar(
                'Error', e.message ?? 'Phone number verification failed',
                backgroundColor: Colors.red, colorText: Colors.white);
          },
          codeSent: (String verificationId, int? resendToken) {
            DialogHelper.hideDialog();
            Get.snackbar('OTP Sent', 'An OTP has been sent to your phone',
                backgroundColor: Colors.blue, colorText: Colors.white);

            // Navigate to OTP verification screen with the verification ID
            Get.toNamed(Routes.SIGNUP_SUCCESS, arguments: {
              "verificationId": verificationId,
              "phoneNo": completePhoneNumber
            });
          },
          codeAutoRetrievalTimeout: (String verificationId) {
            // Auto-retrieval timeout
          },
        );
      } catch (e) {
        DialogHelper.hideDialog();
        Get.snackbar('Error', 'Failed to send OTP',
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } else {
      Get.snackbar('Error', 'Please enter valid details',
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  @override
  void onClose() {
    phoneController.dispose();
    super.onClose();
  }
}
