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
    apiKey: 'AIzaSyAzRzk9-w72kNVEz2vFpW0kTF-OwCV9BEU',
    appId: '1:558029745257:web:03db348529bf628aca86f8',
    messagingSenderId: '558029745257',
    projectId: 'nfc-reader-ucb',
    authDomain: 'nfc-reader-ucb.firebaseapp.com',
    storageBucket: 'nfc-reader-ucb.appspot.com',
    measurementId: 'G-VMENXXHZ0H',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBciW9UwGV5J_bwzndTkqlc3H9dPtlW2Hg',
    appId: '1:558029745257:android:3cfead6ed7249d78ca86f8',
    messagingSenderId: '558029745257',
    projectId: 'nfc-reader-ucb',
    storageBucket: 'nfc-reader-ucb.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyD-DJA-zX-PY6yy8c10bnJlRg29IuHsOZQ',
    appId: '1:558029745257:ios:88a46c911ffabb81ca86f8',
    messagingSenderId: '558029745257',
    projectId: 'nfc-reader-ucb',
    storageBucket: 'nfc-reader-ucb.appspot.com',
    iosBundleId: 'com.example.nfcReader',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyD-DJA-zX-PY6yy8c10bnJlRg29IuHsOZQ',
    appId: '1:558029745257:ios:a53b129523a65a94ca86f8',
    messagingSenderId: '558029745257',
    projectId: 'nfc-reader-ucb',
    storageBucket: 'nfc-reader-ucb.appspot.com',
    iosBundleId: 'com.example.nfcReader.RunnerTests',
  );
}
