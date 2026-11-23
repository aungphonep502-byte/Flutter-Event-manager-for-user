import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with the Firebase apps.
//Stores Firebase settings for different platforms.
class DefaultFirebaseOptions {
  //Gets the correct Firebase settings for the current platform.
  //Needed because different platforms may have different settings.
  static FirebaseOptions get currentPlatform {
    // Checks if the app is running on a web browser.
    if (kIsWeb) {
      return web; // Uses the web Firebase settings.
    }
    // Checks which platform the app is running on.
    switch (defaultTargetPlatform) {
      // Uses Android Firebase settings.
      case TargetPlatform.android:
        return android;
      // Uses iOS Firebase settings.
      case TargetPlatform.iOS:
        return ios;
      // Uses macOS Firebase settings.
      case TargetPlatform.macOS:
        return macos;
      // Uses Windows Firebase settings.
      case TargetPlatform.windows:
        return windows;
      // Shows an error because Linux is not configured.
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      // Shows an error if the platform is not supported.
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }
  // Stores Firebase settings for the web application.
  // Needed when the app runs in a web browser.
  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyA1gk9X8aihL6e1UL2MDNZtJZXBNvUe6z0',
    appId: '1:97635559823:web:666a503561af0990c6c3fa',
    messagingSenderId: '97635559823',
    projectId: 'authapp-56ba0',
    authDomain: 'authapp-56ba0.firebaseapp.com',
    storageBucket: 'authapp-56ba0.firebasestorage.app',
    measurementId: 'G-EBSFDW3RMG',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAon09l0Z1ZcDQ2BYQmSzP4eyacCjN0wow',
    appId: '1:97635559823:android:f75a754fb3150af2c6c3fa',
    messagingSenderId: '97635559823',
    projectId: 'authapp-56ba0',
    storageBucket: 'authapp-56ba0.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBOyBZVqdtj6L_gNazQpTuw8hxZn7GSa0E',
    appId: '1:97635559823:ios:f12caf1290ec4502c6c3fa',
    messagingSenderId: '97635559823',
    projectId: 'authapp-56ba0',
    storageBucket: 'authapp-56ba0.firebasestorage.app',
    iosBundleId: 'com.example.myNewApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBOyBZVqdtj6L_gNazQpTuw8hxZn7GSa0E',
    appId: '1:97635559823:ios:f12caf1290ec4502c6c3fa',
    messagingSenderId: '97635559823',
    projectId: 'authapp-56ba0',
    storageBucket: 'authapp-56ba0.firebasestorage.app',
    iosBundleId: 'com.example.myNewApp',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyA1gk9X8aihL6e1UL2MDNZtJZXBNvUe6z0',
    appId: '1:97635559823:web:1722de86963ee061c6c3fa',
    messagingSenderId: '97635559823',
    projectId: 'authapp-56ba0',
    authDomain: 'authapp-56ba0.firebaseapp.com',
    storageBucket: 'authapp-56ba0.firebasestorage.app',
    measurementId: 'G-3C0YC0MWEY',
  );
}
