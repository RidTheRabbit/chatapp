// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
        return windows;
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
    apiKey: 'AIzaSyBSe6hEivrWzSOmCEyQR6ah1RGA_8U9qQk',
    appId: '1:412760761760:web:5996a85569e2c5c7d070c5',
    messagingSenderId: '412760761760',
    projectId: 'chat-app-e924b',
    authDomain: 'chat-app-e924b.firebaseapp.com',
    storageBucket: 'chat-app-e924b.appspot.com',
    measurementId: 'G-JSWB2375P5',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCI5AwwiGSFJkmRcJ_XghezDRlMMysF9Sg',
    appId: '1:412760761760:android:402b11939d27af41d070c5',
    messagingSenderId: '412760761760',
    projectId: 'chat-app-e924b',
    storageBucket: 'chat-app-e924b.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCDdiamZZH3B6ja-U7epKb5xwFt734XuGE',
    appId: '1:412760761760:ios:91fb6d47cf74ff38d070c5',
    messagingSenderId: '412760761760',
    projectId: 'chat-app-e924b',
    storageBucket: 'chat-app-e924b.appspot.com',
    iosBundleId: 'com.example.chatapp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCDdiamZZH3B6ja-U7epKb5xwFt734XuGE',
    appId: '1:412760761760:ios:91fb6d47cf74ff38d070c5',
    messagingSenderId: '412760761760',
    projectId: 'chat-app-e924b',
    storageBucket: 'chat-app-e924b.appspot.com',
    iosBundleId: 'com.example.chatapp',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBSe6hEivrWzSOmCEyQR6ah1RGA_8U9qQk',
    appId: '1:412760761760:web:a9e49e4ffd7410d3d070c5',
    messagingSenderId: '412760761760',
    projectId: 'chat-app-e924b',
    authDomain: 'chat-app-e924b.firebaseapp.com',
    storageBucket: 'chat-app-e924b.appspot.com',
    measurementId: 'G-EW6W1DMGC2',
  );
}