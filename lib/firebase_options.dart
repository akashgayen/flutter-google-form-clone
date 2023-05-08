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
    apiKey: 'AIzaSyCg41ABZvKudN_bHBcQYbEhUF1CdNrm9sY',
    appId: '1:429595889852:web:b719f05371b6f7d932c0b9',
    messagingSenderId: '429595889852',
    projectId: 'glug-gforms-clone',
    authDomain: 'glug-gforms-clone.firebaseapp.com',
    storageBucket: 'glug-gforms-clone.appspot.com',
    measurementId: 'G-DGCQF4X3F8',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAd5Y8xwewyUllZnxdjYWiA3lHHFM0qPAA',
    appId: '1:429595889852:android:dc9c68d0b719511132c0b9',
    messagingSenderId: '429595889852',
    projectId: 'glug-gforms-clone',
    storageBucket: 'glug-gforms-clone.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAslEZVhqIaPkjDrWdzGbJ0cShfWMixmds',
    appId: '1:429595889852:ios:15bd88e077f8240232c0b9',
    messagingSenderId: '429595889852',
    projectId: 'glug-gforms-clone',
    storageBucket: 'glug-gforms-clone.appspot.com',
    iosClientId: '429595889852-14fqpnao1hesurc7cug8q4kc89rm3t8s.apps.googleusercontent.com',
    iosBundleId: 'com.example.gform',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAslEZVhqIaPkjDrWdzGbJ0cShfWMixmds',
    appId: '1:429595889852:ios:15bd88e077f8240232c0b9',
    messagingSenderId: '429595889852',
    projectId: 'glug-gforms-clone',
    storageBucket: 'glug-gforms-clone.appspot.com',
    iosClientId: '429595889852-14fqpnao1hesurc7cug8q4kc89rm3t8s.apps.googleusercontent.com',
    iosBundleId: 'com.example.gform',
  );
}
