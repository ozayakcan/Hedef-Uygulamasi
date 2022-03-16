- [Firebase Cli Kurulumu](https://firebase.google.com/docs/cli)

```
dart pub global activate flutterfire_cli
```

```
flutterfire configure
```

- local.properties örneği
```
sdk.dir=C:\\Users\\Proje\\AppData\\Local\\Android\\sdk
flutter.sdk=C:\\Users\\Proje\\flutter
flutter.buildMode=release
flutter.versionName=0.0.1
flutter.minSdkVersion=23
flutter.targetSdkVersion=32
flutter.compileSdkVersion=32
flutter.versionCode=1
```

- key.properties örneği
```
storePassword=şifre
keyPassword=şifre
keyAlias=release
storeFile=../key/keystore.jks
#Konum android/key/keystore.jks
```

-Firebase Realtime Database kuralları
```
{
  "rules": {
    ".read": true,
    ".write": true,
  }
}
```

- secrets.dart örneği
```
class Secrets {
  static String webRecaptchaSiteKey =
      "6Ldxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx";
}
```

-firebase_options.dart örneği
```
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    // ignore: missing_enum_constant_in_switch
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
    }

    throw UnsupportedError(
      'DefaultFirebaseOptions are not supported for this platform.',
    );
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'firebaseApiKey',
    appId: 'firebaseAppId',
    messagingSenderId: 'firebaseMessagingSenderId',
    projectId: 'firebaseProjectID',
    authDomain: 'firebaseProjectID.firebaseapp.com',
    storageBucket: 'firebaseProjectID.appspot.com',
    databaseURL:
        "firebaseDatabaseUrl",
    measurementId: 'firebasemeasurementId',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'firebaseApiKey',
    appId: 'firebaseAppId',
    messagingSenderId: 'firebaseMessagingSenderId',
    projectId: 'firebaseProjectID',
    storageBucket: 'firebaseProjectID.appspot.com',
    databaseURL:
        "firebaseDatabaseUrl",
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'firebaseApiKey',
    appId: 'firebaseAppId',
    messagingSenderId: 'firebaseMessagingSenderId',
    projectId: 'firebaseProjectID',
    storageBucket: 'firebaseProjectID.appspot.com',
    databaseURL:
        "firebaseDatabaseUrl",
    iosClientId:
        'firebaseIOSClientID.googleusercontent.com',
    iosBundleId: 'com.ozayakcan.sosyal',
  );
}
```