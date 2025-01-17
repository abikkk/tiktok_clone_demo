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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyC6bskbmwjm1fLKAFnHzSUlcPQjURWJBH8',
    appId: '1:136751870306:web:269b2b6dbb76e78c94bc3b',
    messagingSenderId: '136751870306',
    projectId: 'tiktokclone-2fc40',
    authDomain: 'tiktokclone-2fc40.firebaseapp.com',
    storageBucket: 'tiktokclone-2fc40.firebasestorage.app',
    measurementId: 'G-FDPVLQ63EX',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyACZDDjYzWtZS1e0-BKhoSUaFUzuDZGSyw',
    appId: '1:136751870306:android:ea0d4d75e9e3235494bc3b',
    messagingSenderId: '136751870306',
    projectId: 'tiktokclone-2fc40',
    storageBucket: 'tiktokclone-2fc40.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyD0786aP0wq3PyCyf0KgAN4yxgsgt6SnlY',
    appId: '1:136751870306:ios:ac793a72e543bdd894bc3b',
    messagingSenderId: '136751870306',
    projectId: 'tiktokclone-2fc40',
    storageBucket: 'tiktokclone-2fc40.firebasestorage.app',
    iosBundleId: 'com.example.tiktokCloneDemo',
  );
}
