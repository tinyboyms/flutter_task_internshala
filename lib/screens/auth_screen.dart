import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intern_mobile_dev_task/screens/profile_screen.dart';
import '../controllers/auth_controller.dart';

class AuthScreen extends StatelessWidget {
   AuthScreen({super.key});
  final AuthController _authController = Get.find();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _isSignUp = false.obs;

  // Add these for password visibility
  final  _isPasswordVisible = false.obs;
  final  _isConfirmPasswordVisible = false.obs;


  @override
  Widget build(BuildContext context) {
     if (_authController.isLoggedIn.value) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.offAll(() => ProfileScreen());
      });
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.teal, Colors.tealAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _isSignUp.value ? 'Sign Up' : 'Sign In',
                  style: TextStyle(fontSize: 32, color: Colors.white, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    filled: true,
                    // fillColor: Colors.white.withOpacity(0.9),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12),),
                  ),
                ),
                SizedBox(height: 16),

                Obx(() => TextField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    filled: true,
                    // fillColor: Colors.white.withOpacity(0.9),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible.value 
                          ? Icons.visibility 
                          : Icons.visibility_off,
                      ),
                      onPressed: () => _isPasswordVisible.value = !_isPasswordVisible.value,
                    ),
                  ),
                  obscureText: !_isPasswordVisible.value,
                )),

                Obx(() => _isSignUp.value
                    ? Padding(
                  padding: EdgeInsets.only(top: 16),
                  child: TextField(
                    controller: _confirmPasswordController,
                    decoration: InputDecoration(
                      labelText: 'Confirm Password',
                      filled: true,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isConfirmPasswordVisible.value 
                            ? Icons.visibility 
                            : Icons.visibility_off,
                        ),
                        onPressed: () => _isConfirmPasswordVisible.value = !_isConfirmPasswordVisible.value,
                      ),
                    ),
                    obscureText: !_isConfirmPasswordVisible.value,
                  ),
                )
                : SizedBox()),
                SizedBox(height: 24),
                Obx(() => _authController.isLoading.value
                    ? CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(Colors.white))
                    : ElevatedButton(
                  onPressed: () {
                    if (_isSignUp.value && _passwordController.text != _confirmPasswordController.text) {
                      Get.snackbar('Error', 'Passwords do not match');
                      return;
                    }
                    _isSignUp.value
                        ? _authController.signUp(_emailController.text, _passwordController.text)
                        : _authController.signIn(_emailController.text, _passwordController.text);
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text(_isSignUp.value ? 'Sign Up' : 'Sign In', style: TextStyle(fontSize: 18)),
                )),
                SizedBox(height: 16),
                TextButton(
                  onPressed: () => _isSignUp.value = !_isSignUp.value,
                  child: Text(
                    _isSignUp.value ? 'Already have an account? Sign In' : 'Need an account? Sign Up',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}