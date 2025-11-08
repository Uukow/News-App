// This is a placeholder file for Firebase configuration
// You need to add your actual Firebase configuration here

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
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

  // Firebase Android configuration
  static const FirebaseOptions android = FirebaseOptions(
    apiKey:
        'enter your api key here', // TODO: Get from google-services.json -> "current_key" -> "api_key"
    appId: 'enter your app id here',
    messagingSenderId: 'enter your messaging sender id here',
    projectId: 'enter your project id here',
    storageBucket: 'enter your storage bucket here',
  );

  // Firebase iOS configuration
  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'enter your api key here',
    appId: 'enter your app id here',
    messagingSenderId: 'enter your messaging sender id here',
    projectId: 'enter your project id here',
    storageBucket: 'enter your storage bucket here',
    iosBundleId: 'enter your bundle id here',
  );
}
