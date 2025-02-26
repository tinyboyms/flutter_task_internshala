import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../models/user_profile.dart';
import '../controllers/profile_controller.dart';

class EditProfileController extends GetxController {
  final ProfileController _profileController = Get.find();
  
  // Add this getter to access the profile controller
  ProfileController get profileController => _profileController;
  
  final selectedImage = Rxn<File>();
  final isLoading = false.obs;
  
  // Form fields
  final nameController = TextEditingController();
  final raceValue = ''.obs;
  final genderValue = ''.obs;
  final dateValue = DateTime.now().obs;
  final dietaryPreferenceValue = 'Vegan'.obs;
  final allergiesController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    loadCurrentProfile();
  }

  void loadCurrentProfile() {
    final currentProfile = _profileController.userProfile.value;
    if (currentProfile != null) {
      nameController.text = currentProfile.name;
      raceValue.value = currentProfile.race;
      genderValue.value = currentProfile.gender;
      dateValue.value = currentProfile.birthdate;
      dietaryPreferenceValue.value = currentProfile.dietaryPreference;
      allergiesController.text = currentProfile.allergies.join(', ');
    }
  }

  Future<void> updateProfile() async {
    try {
      isLoading.value = true;
      
      final currentProfile = _profileController.userProfile.value;
      
      final updatedProfile = UserProfile(
        name: nameController.text.trim(),
        race: raceValue.value,
        gender: genderValue.value,
        birthdate: dateValue.value,
        dietaryPreference: dietaryPreferenceValue.value,
        allergies: allergiesController.text.isEmpty
            ? []
            : allergiesController.text.split(',').map((e) => e.trim()).toList(),
        // Keep existing image if no new image is selected
        profileImageBase64: selectedImage.value == null 
            ? currentProfile?.profileImageBase64 
            : null,
      );

      await _profileController.saveProfile(updatedProfile, selectedImage.value);
      Get.back();
      Get.snackbar('Success', 'Profile updated successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to update profile');
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    allergiesController.dispose();
    super.onClose();
  }
} 