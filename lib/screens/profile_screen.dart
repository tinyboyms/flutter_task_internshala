import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../controllers/auth_controller.dart';
import '../controllers/profile_controller.dart';
import '../models/user_profile.dart';
import '../screens/auth_screen.dart';
import 'onboarding_screen.dart';
import 'dart:convert';
import '../screens/edit_profile_screen.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});
  final ProfileController _profileController = Get.find();
  final AuthController _authController = Get.find();

  Widget _buildInfoCard(BuildContext context, String title, List<Widget> children) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                color: Colors.teal.shade700,
                fontWeight: FontWeight.bold,
              ),
            ),
            Divider(color: Colors.teal.shade100, thickness: 1.5),
            SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: Colors.teal.shade50,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              _getIconForLabel(label),
              color: Colors.teal,
              size: 20,
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 14,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _getIconForLabel(String label) {
    switch (label) {
      case 'Race':
        return Icons.people;
      case 'Gender':
        return Icons.person;
      case 'Birthdate':
        return Icons.calendar_today;
      case 'Dietary Preference':
        return Icons.restaurant_menu;
      case 'Allergies':
        return Icons.warning_amber;
      default:
        return Icons.info;
    }
  }

  @override
  Widget build(BuildContext context) {
    String? uid = FirebaseAuth.instance.currentUser?.uid;
    
    if (uid == null) {
      Get.offAll(() => AuthScreen());
      return Scaffold(body: Container());
    }

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.teal.shade50, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Obx(() {
            if (_profileController.isLoading.value) {
              return Center(child: CircularProgressIndicator(color: Colors.teal));
            }
            
            if (_profileController.userProfile.value == null) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Get.offAll(() => OnboardingScreen());
              });
              return Center(child: CircularProgressIndicator(color: Colors.teal));
            }
            
            UserProfile profile = _profileController.userProfile.value!;
            return CustomScrollView(
              slivers: [
                SliverAppBar(
                  expandedHeight: 240,
                  floating: false,
                  pinned: true,
                  flexibleSpace: FlexibleSpaceBar(
                    title: Text(
                      profile.name,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    background: Stack(
                      fit: StackFit.expand,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.teal,
                          ),
                        ),
                        // Profile Image
                        Align(
                          alignment: Alignment.center,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 120,
                                height: 120,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 3,
                                  ),
                                  image: profile.profileImageBase64 != null
                                      ? DecorationImage(
                                          image: MemoryImage(
                                            Uint8List.fromList(base64Decode(profile.profileImageBase64!)),
                                          ),
                                          fit: BoxFit.cover,
                                        )
                                      : null,
                                  color: Colors.grey[900],
                                ),
                                child: profile.profileImageBase64 == null
                                    ? Icon(
                                        Icons.person,
                                        size: 60,
                                        color: Colors.white,
                                      )
                                    : null,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  actions: [
                    IconButton(
                      icon: Icon(Icons.edit, color: Colors.white),
                      onPressed: () => Get.to(() => EditProfileScreen()),
                    ),
                    IconButton(
                      icon: Icon(Icons.refresh, color: Colors.white),
                      onPressed: () => _profileController.loadProfile(uid),
                    ),
                    IconButton(
                      icon: Icon(Icons.logout, color: Colors.white),
                      onPressed: () => _authController.signOut(),
                    ),
                  ],
                ),
                SliverPadding(
                  padding: EdgeInsets.all(16),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      _buildInfoCard(
                        context,
                        'Demographics',
                        [
                          _buildInfoItem('Race', profile.race),
                          _buildInfoItem('Gender', profile.gender),
                          _buildInfoItem(
                            'Birthdate',
                            profile.birthdate.toString().substring(0, 10),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      _buildInfoCard(
                        context,
                        'Preferences',
                        [
                          _buildInfoItem(
                            'Dietary Preference',
                            profile.dietaryPreference,
                          ),
                          _buildInfoItem(
                            'Allergies',
                            profile.allergies.isEmpty
                                ? 'None'
                                : profile.allergies.join(', '),
                          ),
                        ],
                      ),
                    ]),
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}