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
    apiKey: 'AIzaSyDGpf_lQGtZBDEo0vgQZQqWdyqYLqbZ4hI',
    appId: '1:123456789:web:abc123def456',
    messagingSenderId: '123456789',
    projectId: 'yallaa-project',
    authDomain: 'yallaa-project.firebaseapp.com',
    storageBucket: 'yallaa-project.appspot.com',
    measurementId: 'G-ABCDEFGHIJ',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDGpf_lQGtZBDEo0vgQZQqWdyqYLqbZ4hI',
    appId: '1:123456789:android:abc123def456',
    messagingSenderId: '123456789',
    projectId: 'yallaa-project',
    authDomain: 'yallaa-project.firebaseapp.com',
    storageBucket: 'yallaa-project.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDGpf_lQGtZBDEo0vgQZQqWdyqYLqbZ4hI',
    appId: '1:123456789:ios:abc123def456',
    messagingSenderId: '123456789',
    projectId: 'yallaa-project',
    authDomain: 'yallaa-project.firebaseapp.com',
    storageBucket: 'yallaa-project.appspot.com',
    iosClientId: '123456789-abc123def456.apps.googleusercontent.com',
    iosBundleId: 'com.yallaa.app',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDGpf_lQGtZBDEo0vgQZQqWdyqYLqbZ4hI',
    appId: '1:123456789:macos:abc123def456',
    messagingSenderId: '123456789',
    projectId: 'yallaa-project',
    authDomain: 'yallaa-project.firebaseapp.com',
    storageBucket: 'yallaa-project.appspot.com',
    iosClientId: '123456789-abc123def456.apps.googleusercontent.com',
    iosBundleId: 'com.yallaa.app',
  );
}
