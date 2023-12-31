// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBu5hqnRwg4GXz1n8e-oNflkO0gM8ejECM',
    appId: '1:222215952770:web:147651a13e5e88e386979b',
    messagingSenderId: '222215952770',
    projectId: 'weather-app-8c16e',
    authDomain: 'weather-app-8c16e.firebaseapp.com',
    storageBucket: 'weather-app-8c16e.appspot.com',
    measurementId: 'G-TLKDCC5LLL',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCA4e3O8p3BciPTr2EeOXPrLaONXAzfG6s',
    appId: '1:222215952770:android:f66b471d2b0c5f2586979b',
    messagingSenderId: '222215952770',
    projectId: 'weather-app-8c16e',
    storageBucket: 'weather-app-8c16e.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyASQugUv63HcfP8ZIbLyhY5Np3jejHn-T0',
    appId: '1:222215952770:ios:d51c742caf3966f386979b',
    messagingSenderId: '222215952770',
    projectId: 'weather-app-8c16e',
    storageBucket: 'weather-app-8c16e.appspot.com',
    iosBundleId: 'com.example.stemmAssignmentWeatherApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyASQugUv63HcfP8ZIbLyhY5Np3jejHn-T0',
    appId: '1:222215952770:ios:5aecd2d9dc19b5b986979b',
    messagingSenderId: '222215952770',
    projectId: 'weather-app-8c16e',
    storageBucket: 'weather-app-8c16e.appspot.com',
    iosBundleId: 'com.example.stemmAssignmentWeatherApp.RunnerTests',
  );
}
