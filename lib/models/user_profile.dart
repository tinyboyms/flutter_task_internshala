import 'dart:convert';
import 'dart:typed_data';

class UserProfile {
  final String name; // Add this field
  final String race;
  final String gender;
  final DateTime birthdate;
  final String dietaryPreference;
  final List<String> allergies;
  final String? profileImageBase64;

  UserProfile({
    required this.name, // Add this field
    required this.race,
    required this.gender,
    required this.birthdate,
    required this.dietaryPreference,
    required this.allergies,
    this.profileImageBase64,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name, // Add this field
      'race': race,
      'gender': gender,
      'birthdate': birthdate.toIso8601String(),
      'dietaryPreference': dietaryPreference,
      'allergies': allergies,
      'profileImageBase64': profileImageBase64,
    };
  }

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      name: map['name'] ?? '', // Add this line
      race: map['race'] ?? '',
      gender: map['gender'] ?? '',
      birthdate: DateTime.parse(map['birthdate'] ?? DateTime.now().toIso8601String()),
      dietaryPreference: map['dietaryPreference'] ?? '',
      allergies: List<String>.from(map['allergies'] ?? []),
      profileImageBase64: map['profileImageBase64'],
    );
  }
}