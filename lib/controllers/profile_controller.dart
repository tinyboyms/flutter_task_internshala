import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;

import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../screens/onboarding_screen.dart';
import '../services/firebase_service.dart';
import '../models/user_profile.dart';
import '../screens/profile_screen.dart';

class ProfileController extends GetxController {
  final FirebaseService _firebaseService = FirebaseService();
  final isLoading = false.obs;
  final userProfile = Rxn<UserProfile>();

  Future<bool> hasProfileData(String uid) async {
    try {
      Map<String, dynamic>? data = await _firebaseService.getProfile(uid);
      return data != null;
    } catch (e) {
      return false;
    }
  }

  Future<String?> convertImageToBase64(File imageFile) async {
    try {
      // Read and decode image
      Uint8List imageBytes = await imageFile.readAsBytes();
      img.Image? originalImage = img.decodeImage(Uint8List.fromList(imageBytes));
      
      if (originalImage == null) return null;

      // Resize image to smaller dimensions (e.g., 300x300)
      img.Image resizedImage = img.copyResize(
        originalImage,
        width: 300,
        height: 300,
      );

      // Encode to JPEG with compression
      List<int> compressedBytes = img.encodeJpg(resizedImage, quality: 70);
      
      // Convert compressed bytes to base64
      String base64Image = base64Encode(Uint8List.fromList(compressedBytes));
      
      return base64Image;
    } catch (e) {
      return null;
    }
  }

  Future<void> saveProfile(UserProfile profile, File? imageFile) async {
    try {
      isLoading.value = true;
      String? uid = FirebaseAuth.instance.currentUser?.uid;
      
      if (uid == null) {
        Get.snackbar('Error', 'User not logged in');
        return;
      }

      // If there's a new image, convert it to base64
      String? base64Image;
      if (imageFile != null) {
        base64Image = await convertImageToBase64(imageFile);
      }

      // Create updated profile with image
      final updatedProfile = UserProfile(
        name:profile.name,
        race: profile.race,
        gender: profile.gender,
        birthdate: profile.birthdate,
        dietaryPreference: profile.dietaryPreference,
        allergies: profile.allergies,
        profileImageBase64: base64Image ?? profile.profileImageBase64,
      );

      // Save to Firestore
      await _firebaseService.saveProfile(uid, updatedProfile.toMap());
      
      // Update local state
      userProfile.value = updatedProfile;
      
      // Navigate to profile screen
      Get.offAll(() => ProfileScreen());
    } catch (e) {
      Get.snackbar('Error', 'Failed to save profile');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadProfile(String uid) async {
    try {
      isLoading.value = true;
      Map<String, dynamic>? data = await _firebaseService.getProfile(uid);
      
      if (data != null) {
        userProfile.value = UserProfile.fromMap(data);
      } else {
        Get.offAll(() => OnboardingScreen());
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load profile. Please try again.',
        duration: Duration(seconds: 3),
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onInit() {
    super.onInit();
    // Auto-load profile if user is logged in
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      loadProfile(user.uid);
    }
  }
}