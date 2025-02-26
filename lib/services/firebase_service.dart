import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  Future<Map<String, dynamic>> signUp(String email, String password) async {
    try {
      // Validate password strength
      if (password.length < 8) {
        return {'error': 'Password must be at least 8 characters long'};
      }
      if (!password.contains(RegExp(r'[A-Z]'))) {
        return {'error': 'Password must contain at least one uppercase letter'};
      }
      if (!password.contains(RegExp(r'[0-9]'))) {
        return {'error': 'Password must contain at least one number'};
      }

      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return {'user': userCredential.user};
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'email-already-in-use':
          return {'error': 'This email is already registered'};
        case 'invalid-email':
          return {'error': 'Invalid email address'};
        case 'weak-password':
          return {'error': 'Password is too weak'};
        default:
          return {'error': 'Sign up failed. Please try again.'};
      }
    }
  }

  Future<Map<String, dynamic>> signIn(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return {'user': userCredential.user};
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found':
          return {'error': 'No user found with this email'};
        case 'wrong-password':
          return {'error': 'Incorrect password'};
        case 'user-disabled':
          return {'error': 'This account has been disabled'};
        default:
          return {'error': 'Sign in failed. Please try again.'};
      }
    }
  }

  Future<void> saveProfile(String uid, Map<String, dynamic> profileData) async {
    await _firestore.collection('users').doc(uid).set(profileData, SetOptions(merge: true));
  }

  Future<Map<String, dynamic>?> getProfile(String uid) async {
    DocumentSnapshot doc = await _firestore.collection('users').doc(uid).get();
    return doc.data() as Map<String, dynamic>?;
  }
}