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
    apiKey: 'AIzaSyAGT231uUvobo9xpQe4zaSPD1MY_TrmLJM',
    appId: '1:208731041576:web:6316f9da3755062931aa1d',
    messagingSenderId: '208731041576',
    projectId: 'whatsapp-clone-8adc6',
    authDomain: 'whatsapp-clone-8adc6.firebaseapp.com',
    storageBucket: 'whatsapp-clone-8adc6.appspot.com',
    measurementId: 'G-N436XS9LE0',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBnlHtUHTM480GrB5fni3rfC-vXvq1H-MY',
    appId: '1:208731041576:android:e0b30e11d9b3d46f31aa1d',
    messagingSenderId: '208731041576',
    projectId: 'whatsapp-clone-8adc6',
    storageBucket: 'whatsapp-clone-8adc6.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDN732XN-wvGF6eFf3vpKz6fdg-PRXTpUU',
    appId: '1:208731041576:ios:d6a8af4e920c0ec931aa1d',
    messagingSenderId: '208731041576',
    projectId: 'whatsapp-clone-8adc6',
    storageBucket: 'whatsapp-clone-8adc6.appspot.com',
    iosBundleId: 'com.example.whatsappClone',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAGT231uUvobo9xpQe4zaSPD1MY_TrmLJM',
    appId: '1:208731041576:web:72acdc4e617f4f8331aa1d',
    messagingSenderId: '208731041576',
    projectId: 'whatsapp-clone-8adc6',
    authDomain: 'whatsapp-clone-8adc6.firebaseapp.com',
    storageBucket: 'whatsapp-clone-8adc6.appspot.com',
    measurementId: 'G-NDT86KQVVK',
  );
}
