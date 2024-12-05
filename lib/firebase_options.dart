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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for ios - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyD1JMOu0MUG7uI5gCBe5_u-IfYFk8VXhKg',
    appId: '1:538856819358:web:566cfc1262df4416d1098f',
    messagingSenderId: '538856819358',
    projectId: 'journalapp-851cb',
    authDomain: 'journalapp-851cb.firebaseapp.com',
    storageBucket: 'journalapp-851cb.appspot.com',
    measurementId: 'G-56P7HMWCXF',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDalM7VVsjWknjbKjQL6w59LH2XpPSqllw',
    appId: '1:538856819358:android:27e64554edd661fdd1098f',
    messagingSenderId: '538856819358',
    projectId: 'journalapp-851cb',
    storageBucket: 'journalapp-851cb.appspot.com',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyD1JMOu0MUG7uI5gCBe5_u-IfYFk8VXhKg',
    appId: '1:538856819358:web:f67eaf7adcdd4b65d1098f',
    messagingSenderId: '538856819358',
    projectId: 'journalapp-851cb',
    authDomain: 'journalapp-851cb.firebaseapp.com',
    storageBucket: 'journalapp-851cb.appspot.com',
    measurementId: 'G-VPECY9MZSS',
  );
}