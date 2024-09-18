import 'package:get/get.dart';
import 'dart:io';

class GetUserDetailsController extends GetxController {
  // Observables for user details
  Rx<File?> userImage = Rx<File?>(null);
  RxString name = ''.obs;
  RxString gender = ''.obs;
  Rx<DateTime?> selectedDate = Rx<DateTime?>(null);

  // Function to update the user's name
  void updateName(String newName) {
    name.value = newName;
  }

  // Function to update the user's gender
  void updateGender(String newGender) {
    gender.value = newGender;
  }

  // Function to update the selected date of birth
  void updateDateOfBirth(DateTime date) {
    selectedDate.value = date;
  }

  // Function to update the user's image
  void updateImage(File? image) {
    userImage.value = image;
  }

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
}
