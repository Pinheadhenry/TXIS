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
    apiKey: 'AIzaSyBhtwhJK9yJeFbpiDuRYn8rTt-PRcCRtjI',
    appId: '1:607131724212:web:9645c2faf4c1fc8aca6ae1',
    messagingSenderId: '607131724212',
    projectId: 'texas-iron-spikes',
    authDomain: 'texas-iron-spikes.firebaseapp.com',
    storageBucket: 'texas-iron-spikes.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyA1DbiqDeqJj4g5BCQY3fPO5RMv7iKe5vc',
    appId: '1:607131724212:android:51465a5460870304ca6ae1',
    messagingSenderId: '607131724212',
    projectId: 'texas-iron-spikes',
    storageBucket: 'texas-iron-spikes.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCzKCs8a6ktseb_ATm4XR_L68zu0d9tL5Q',
    appId: '1:607131724212:ios:e1f000909f52e68eca6ae1',
    messagingSenderId: '607131724212',
    projectId: 'texas-iron-spikes',
    storageBucket: 'texas-iron-spikes.firebasestorage.app',
    iosBundleId: 'com.example.texasIronSpikes',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCzKCs8a6ktseb_ATm4XR_L68zu0d9tL5Q',
    appId: '1:607131724212:ios:e1f000909f52e68eca6ae1',
    messagingSenderId: '607131724212',
    projectId: 'texas-iron-spikes',
    storageBucket: 'texas-iron-spikes.firebasestorage.app',
    iosBundleId: 'com.example.texasIronSpikes',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBhtwhJK9yJeFbpiDuRYn8rTt-PRcCRtjI',
    appId: '1:607131724212:web:847827556f80b742ca6ae1',
    messagingSenderId: '607131724212',
    projectId: 'texas-iron-spikes',
    authDomain: 'texas-iron-spikes.firebaseapp.com',
    storageBucket: 'texas-iron-spikes.firebasestorage.app',
  );
}
