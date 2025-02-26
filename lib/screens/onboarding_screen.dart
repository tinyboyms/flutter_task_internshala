import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/profile_controller.dart';
import '../models/user_profile.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';

class OnboardingScreen extends StatelessWidget {
  final ProfileController _profileController = Get.find();
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  var _selectedRace = ''.obs;
  var _selectedDate = DateTime.now().obs;
  var _selectedGender = ''.obs;
  var _dietaryPreference = 'Vegan'.obs;
  final _allergiesController = TextEditingController();
  final _selectedImage = Rxn<File>();
  final _imagePicker = ImagePicker();

  final List<String> raceOptions = [
    'Asian',
    'African',
    'White/Caucasian',
    'Hispanic/Latino',
    'Middle Eastern',
    'Pacific Islander',
    'Native American',
    'Mixed/Multiple',
    'Other'
  ];

  final List<String> dietaryOptions = ['Vegan', 'Vegetarian', 'Keto', 'Halal', 'No Preference'];

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate.value,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.teal,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate.value) {
      _selectedDate.value = picked;
    }
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );
      if (image != null) {
        _selectedImage.value = File(image.path);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to pick image');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.teal.shade50, Colors.white],
          ),
        ),
        child: SafeArea(
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Profile Image Picker
                    Center(
                      child: Column(
                        children: [
                          Obx(() => GestureDetector(
                            onTap: _pickImage,
                            child: Container(
                              width: 120,
                              height: 120,
                              decoration: BoxDecoration(
                                color: Colors.teal.shade50,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.teal.shade200,
                                  width: 2,
                                ),
                                image: _selectedImage.value != null
                                    ? DecorationImage(
                                        image: FileImage(_selectedImage.value!),
                                        fit: BoxFit.cover,
                                      )
                                    : null,
                              ),
                              child: _selectedImage.value == null
                                  ? Icon(
                                      Icons.add_a_photo,
                                      size: 40,
                                      color: Colors.teal.shade300,
                                    )
                                  : null,
                            ),
                          )),
                          SizedBox(height: 8),
                          Text(
                            'Add Profile Photo',
                            style: TextStyle(
                              color: Colors.teal.shade700,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 24),
                    Center(
                      child: Column(
                        children: [
                          // CircleAvatar(
                          //   radius: 50,
                          //   backgroundColor: Colors.teal.shade100,
                          //   child: Image.asset(
                          //     'assets/images/profile_avatar.png',
                          //     width: 60,
                          //     height: 60,
                          //   ),
                          // ),
                          SizedBox(height: 16),
                          Text(
                            'Tell Us About You',
                            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              color: Colors.teal.shade700,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Help us personalize your experience',
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 32),
                    
                    // Demographics Card
                    Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                // Image.asset(
                                //   'assets/images/demographics.png',
                                //   width: 32,
                                //   height: 32,
                                // ),
                                SizedBox(width: 12),
                                Text(
                                  'Demographics',
                                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                    color: Colors.teal.shade700,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            Divider(color: Colors.teal.shade100),
                            SizedBox(height: 16),
                            
                            // Race Dropdown
                            Obx(() => DropdownButtonFormField<String>(
                              value: _selectedRace.value.isEmpty ? null : _selectedRace.value,
                              items: raceOptions.map((String race) {
                                return DropdownMenuItem(value: race, child: Text(race));
                              }).toList(),
                              onChanged: (value) => _selectedRace.value = value!,
                              decoration: InputDecoration(
                                labelText: 'Race',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                filled: true,
                                fillColor: Colors.teal.shade50,
                                prefixIcon: Icon(Icons.people, color: Colors.teal),
                              ),
                              validator: (value) => value == null || value.isEmpty ? 'Required' : null,
                            )),
                            SizedBox(height: 16),

                            // Gender Selection
                            Text('Gender', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                            Obx(() => Column(
                              children: [
                                RadioListTile<String>(
                                  title: Text('Male'),
                                  value: 'Male',
                                  groupValue: _selectedGender.value,
                                  onChanged: (value) => _selectedGender.value = value!,
                                  activeColor: Colors.teal,
                                  contentPadding: EdgeInsets.zero,
                                ),
                                RadioListTile<String>(
                                  title: Text('Female'),
                                  value: 'Female',
                                  groupValue: _selectedGender.value,
                                  onChanged: (value) => _selectedGender.value = value!,
                                  activeColor: Colors.teal,
                                  contentPadding: EdgeInsets.zero,
                                ),
                                RadioListTile<String>(
                                  title: Text('Other'),
                                  value: 'Other',
                                  groupValue: _selectedGender.value,
                                  onChanged: (value) => _selectedGender.value = value!,
                                  activeColor: Colors.teal,
                                  contentPadding: EdgeInsets.zero,
                                ),
                              ],
                            )),

                            // Birthdate
                            SizedBox(height: 16),
                            Obx(() => InkWell(
                              onTap: () => _selectDate(context),
                              child: InputDecorator(
                                decoration: InputDecoration(
                                  labelText: 'Birthdate',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  filled: true,
                                  fillColor: Colors.teal.shade50,
                                  prefixIcon: Icon(Icons.calendar_today, color: Colors.teal),
                                ),
                                child: Text(
                                  _selectedDate.value.toString().substring(0, 10),
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                            )),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: 24),

                    // Preferences Card
                    Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                // Image.asset(
                                //   'assets/images/preferences.png',
                                //   width: 32,
                                //   height: 32,
                                // ),
                                SizedBox(width: 12),
                                Text(
                                  'Preferences',
                                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                    color: Colors.teal.shade700,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            Divider(color: Colors.teal.shade100),
                            SizedBox(height: 16),

                            // Dietary Preference
                            Obx(() => DropdownButtonFormField<String>(
                              value: _dietaryPreference.value,
                              items: dietaryOptions.map((String option) {
                                return DropdownMenuItem(value: option, child: Text(option));
                              }).toList(),
                              onChanged: (value) => _dietaryPreference.value = value!,
                              decoration: InputDecoration(
                                labelText: 'Dietary Preference',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                filled: true,
                                fillColor: Colors.teal.shade50,
                                prefixIcon: Icon(Icons.restaurant_menu, color: Colors.teal),
                              ),
                            )),

                            SizedBox(height: 16),

                            // Allergies
                            TextFormField(
                              controller: _allergiesController,
                              decoration: InputDecoration(
                                labelText: 'Allergies (comma-separated)',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                filled: true,
                                fillColor: Colors.teal.shade50,
                                prefixIcon: Icon(Icons.warning_amber, color: Colors.teal),
                              ),
                              maxLines: 2,
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: 32),

                    // Name Field
                    TextField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: 'Name',
                        hintText: 'Enter your full name',
                        prefixIcon: Icon(Icons.person_outline, color: Colors.grey),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),

                    SizedBox(height: 32),

                    // Submit Button
                    Obx(() => _profileController.isLoading.value
                      ? Center(child: CircularProgressIndicator())
                      : ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate() && 
                                _selectedGender.value.isNotEmpty &&
                                _nameController.text.isNotEmpty) {
                              try {
                                UserProfile profile = UserProfile(
                                  name: _nameController.text.trim(),
                                  race: _selectedRace.value,
                                  gender: _selectedGender.value,
                                  birthdate: _selectedDate.value,
                                  dietaryPreference: _dietaryPreference.value,
                                  allergies: _allergiesController.text.isEmpty
                                      ? []
                                      : _allergiesController.text.split(',').map((e) => e.trim()).toList(),
                                );

                                await _profileController.saveProfile(profile, _selectedImage.value);
                              } catch (e) {
                                print('Error in save button: $e');
                                Get.snackbar('Error', 'Failed to save profile');
                              }
                            } else {
                              Get.snackbar(
                                'Error', 
                                'Please fill in all required fields',
                                backgroundColor: Colors.red,
                                colorText: Colors.white,
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(double.infinity, 56),
                            backgroundColor: Colors.teal,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 2,
                          ),
                          child: Text(
                            'Save & Continue',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ),
                    SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}