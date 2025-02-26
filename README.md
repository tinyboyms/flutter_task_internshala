# Flutter Intern Task

A Flutter application that demonstrates user profile management with Firebase integration.

## Features

- User Profile Management
- Image Upload and Storage
- Form Validation
- Firebase Integration
- Environment Variable Configuration

## Prerequisites

Before you begin, ensure you have:
- Flutter SDK (latest stable version)
- Android Studio / VS Code
- Git
- Firebase Account
- iOS development requires a Mac with Xcode installed

## Getting Started

### 1. Clone the Repository

git clone https://github.com/tinyboyms/flutter_intern_task.git
cd flutter_intern_task


### 2. Firebase Setup

1. Create a new Firebase project at [Firebase Console](https://console.firebase.google.com/)
2. Add Android App:
    - Package name: `com.example.intern_mobile_dev_task`
    - Download `google-services.json`
    - Place it in `android/app/`
3. Add iOS App:
    - Bundle ID: `com.example.internMobileDevTask`
    - Download `GoogleService-Info.plist`
    - Place it in `ios/Runner/`

### 3. Environment Setup

1. Create a `.env` file in the project root:

Firebase Android:
FIREBASE_ANDROID_API_KEY=your_android_api_key
FIREBASE_ANDROID_APP_ID=your_android_app_id
FIREBASE_ANDROID_MESSAGING_SENDER_ID=your_sender_id
FIREBASE_ANDROID_PROJECT_ID=your_project_id
FIREBASE_ANDROID_STORAGE_BUCKET=your_storage_bucket


Firebase iOS:
FIREBASE_IOS_API_KEY=your_ios_api_key
FIREBASE_IOS_APP_ID=your_ios_app_id
FIREBASE_IOS_MESSAGING_SENDER_ID=your_sender_id
FIREBASE_IOS_PROJECT_ID=your_project_id
FIREBASE_IOS_STORAGE_BUCKET=your_storage_bucket
FIREBASE_IOS_BUNDLE_ID=com.example.internMobileDevTask


### 4. Install Dependencies

    flutter pub get



### 5. Run the App

   -> For Android
        
        flutter run

   -> For iOS (requires Mac)

        cd ios
        pod install
        cd ..
        flutter run



## Common Issues and Solutions

### Android Build Issues

1. **Gradle Version Mismatch**
    - Update `android/gradle/wrapper/gradle-wrapper.properties`
    - Use `distributionUrl=https\://services.gradle.org/distributions/gradle-7.5-all.zip`

2. **Firebase Configuration Error**
    - Ensure `google-services.json` is in the correct location
    - Check package name matches in `android/app/build.gradle`
    - Verify Firebase configuration in `.env` file

### iOS Build Issues

1. **Pod Installation Fails**
   ```bash
   cd ios
   pod repo update
   pod install
   ```

2. **Firebase Configuration Error**
    - Verify `GoogleService-Info.plist` is in the correct location
    - Check Bundle ID matches in Xcode
    - Ensure Firebase iOS configuration in `.env` is correct

### Environment Variables Not Loading

1. Check if `.env` file exists in project root
2. Verify file is not renamed (e.g., `.env.txt`)
3. Ensure `flutter_dotenv` is properly configured in `pubspec.yaml`:
   ```yaml
   dependencies:
     flutter_dotenv: ^5.0.2

   flutter:
     assets:
       - .env
   ```


## Project Structure

      lib/
      ├── controllers/ # GetX controllers
      ├── models/ # Data models
      ├── screens/ # UI screens
      ├── widgets/ # Reusable widgets
      ├── firebase_options.dart # Firebase configuration
      └── main.dart # Entry point


## Development Environment

- Flutter: 3.x.x
- Dart: 3.x.x
- Android Studio: Latest version
- Xcode: Latest version (for iOS development)
- Firebase CLI: Latest version

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## Security

- Never commit `.env` file
- Never commit Firebase configuration files
- Use environment variables for sensitive data
- Keep API keys private


## Acknowledgments

- Flutter Team
- Firebase
- GetX State Management
- Flutter Community




