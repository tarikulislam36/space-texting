import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:space_texting/app/services/dialog_helper.dart';

class EditProfileController extends GetxController {
  // Rx variables to handle state
  var name = ''.obs;
  var profilePicUrl = ''.obs;
  File? selectedImage;

  // Firebase instances
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Fetch user data from Firestore
  @override
  void onInit() {
    super.onInit();
    fetchUserData();
  }

  // Fetch user data from Firestore
  Future<void> fetchUserData() async {
    try {
      String uid = _auth.currentUser!.uid;
      var userDoc = await _firestore.collection('users').doc(uid).get();

      if (userDoc.exists) {
        name.value = userDoc.data()!['name'] ?? '';
        profilePicUrl.value = userDoc.data()!['profilePic'] ?? '';
      }
      print("user doc ${userDoc.data()}");
      update();
    } catch (e) {
      Get.snackbar("Error", "Failed to load user data");
    }
  }

  // Select image from gallery
  Future<void> pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      selectedImage = File(pickedFile.path);
      print("Update called");
      update();
    }
    update();
  }

  // Upload profile picture to Firebase Storage
  Future<String?> uploadProfilePic(File image) async {
    try {
      String uid = _auth.currentUser!.uid;
      Reference ref = _storage.ref().child('profilePics').child('$uid.jpg');
      UploadTask uploadTask = ref.putFile(image);
      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      Get.snackbar("Error", "Failed to upload profile picture");
      return null;
    }
  }

  // Update user profile in Firestore
  Future<void> updateProfile(String newName, File? newProfilePic) async {
    DialogHelper.showLoading();
    try {
      String uid = _auth.currentUser!.uid;
      String? imageUrl;

      if (newProfilePic != null) {
        imageUrl = await uploadProfilePic(newProfilePic);
      }

      // Update Firestore document
      await _firestore.collection('users').doc(uid).update({
        'name': newName,
        if (imageUrl != null) 'profilePic': imageUrl,
      });

      // Update local state
      name.value = newName;
      if (imageUrl != null) profilePicUrl.value = imageUrl;
      DialogHelper.hideDialog();
      // Get.snackbar("Success", "Profile updated successfully!");
      Get.back();
    } catch (e) {
      Get.snackbar("Error", "Failed to update profile");
    }
    DialogHelper.hideDialog();
  }
}
