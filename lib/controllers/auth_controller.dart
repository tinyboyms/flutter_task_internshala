import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:intern_mobile_dev_task/controllers/profile_controller.dart';
import '../screens/auth_screen.dart';
import '../services/firebase_service.dart';
import '../screens/onboarding_screen.dart';
import '../screens/profile_screen.dart';


class AuthController extends GetxController {
  final FirebaseService _firebaseService = FirebaseService();
  final ProfileController _profileController = Get.find();
  var isLoading = false.obs;
  var isLoggedIn = false.obs;

  @override
  void onInit() {
    super.onInit();
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      isLoggedIn.value = user != null;
    });
  }

  Future<void> _handleSuccessfulAuth(User user) async {
    // Check if user has profile data
    bool hasProfile = await _profileController.hasProfileData(user.uid);
    if (hasProfile) {
      Get.offAll(() => ProfileScreen());
    } else {
      Get.offAll(() => OnboardingScreen());
    }
  }

  Future<void> signUp(String email, String password) async {
    if (!GetUtils.isEmail(email)) {
      Get.snackbar('Error', 'Please enter a valid email address');
      return;
    }

    isLoading.value = true;
    final result = await _firebaseService.signUp(email, password);
    isLoading.value = false;

    if (result.containsKey('error')) {
      Get.snackbar('Error', result['error']);
    } else if (result['user'] != null) {
      Get.off(() => OnboardingScreen());
    }
  }

  Future<void> signIn(String email, String password) async {
    if (!GetUtils.isEmail(email)) {
      Get.snackbar('Error', 'Please enter a valid email address');
      return;
    }

    isLoading.value = true;
    final result = await _firebaseService.signIn(email, password);
    isLoading.value = false;

    if (result.containsKey('error')) {
      Get.snackbar('Error', result['error']);
    } else if (result['user'] != null) {
      await _handleSuccessfulAuth(result['user']);
    }
  }

  Future<void> signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      Get.offAll(() => AuthScreen());
    }
    catch (e) {
      Get.snackbar('Error', 'Failed to sign out');
    }
  }
}