import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/edit_profile_controller.dart';
import '../widgets/profile_image_picker.dart';
import '../widgets/profile_form_field.dart';

class EditProfileScreen extends StatelessWidget {
  EditProfileScreen({super.key});

  final EditProfileController controller = Get.put(EditProfileController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: Text('Edit Profile', style: TextStyle(color: Colors.black)),
        actions: [
          Obx(() => controller.isLoading.value
              ? Center(child: CircularProgressIndicator())
              : IconButton(
                  icon: Icon(Icons.save, color: Colors.black),
                  onPressed: controller.updateProfile,
                )),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            // Profile Image
            Center(
              child: Column(
                children: [
                  Obx(() => ProfileImagePicker(
                        currentImage: controller.selectedImage.value,
                        currentImageBase64: controller.profileController
                            .userProfile.value?.profileImageBase64,
                        onImagePicked: (file) =>
                            controller.selectedImage.value = file,
                      )),
                  SizedBox(height: 8),
                  Text(
                    'Tap to change profile photo',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            SizedBox(height: 24),

            // Name
            ProfileFormField(
              label: 'Name',
              icon: Icons.person_outline,
              child: TextField(
                controller: controller.nameController,
                style: TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  hintText: 'Enter your name',
                  prefixIcon: Icon(Icons.person_outline),
                ),
              ),
            ),

            // Race
            ProfileFormField(
              label: 'Race',
              icon: Icons.people_outline,
              child: Obx(() => DropdownButtonFormField<String>(
                    value: controller.raceValue.value.isEmpty
                        ? null
                        : controller.raceValue.value,
                    items: [
                      'Asian',
                      'African',
                      'White/Caucasian',
                      'Hispanic/Latino',
                      'Middle Eastern',
                      'Pacific Islander',
                      'Native American',
                      'Mixed/Multiple',
                      'Other'
                    ].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (value) => controller.raceValue.value = value!,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.people_outline),
                    ),
                  )),
            ),

            // Gender
            ProfileFormField(
              label: 'Gender',
              icon: Icons.person_outline,
              child: Obx(() => DropdownButtonFormField<String>(
                    value: controller.genderValue.value.isEmpty
                        ? null
                        : controller.genderValue.value,
                    items: ['Male', 'Female', 'Other'].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (value) => controller.genderValue.value = value!,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.person_outline),
                    ),
                  )),
            ),

            // Birthdate
            ProfileFormField(
              label: 'Birthdate',
              icon: Icons.calendar_today,
              child: ListTile(
                leading: Icon(Icons.calendar_today),
                title: Obx(() => Text(
                      controller.dateValue.value.toString().substring(0, 10),
                    )),
                onTap: () async {
                  final DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: controller.dateValue.value,
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                  );
                  if (picked != null) {
                    controller.dateValue.value = picked;
                  }
                },
              ),
            ),

            // Dietary Preference
            ProfileFormField(
              label: 'Dietary Preference',
              icon: Icons.restaurant_menu,
              child: Obx(() => DropdownButtonFormField<String>(
                    value: controller.dietaryPreferenceValue.value,
                    items: [
                      'Vegan',
                      'Vegetarian',
                      'Keto',
                      'Halal',
                      'No Preference'
                    ].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (value) =>
                        controller.dietaryPreferenceValue.value = value!,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.restaurant_menu),
                    ),
                  )),
            ),

            // Allergies
            ProfileFormField(
              label: 'Allergies',
              icon: Icons.warning_amber,
              child: TextField(
                controller: controller.allergiesController,
                style: TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  hintText: 'Enter allergies (comma-separated)',
                  prefixIcon: Icon(Icons.warning_amber),
                ),
                maxLines: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }
} 