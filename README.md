- [Firebase Cli Kurulumu](https://firebase.google.com/docs/cli)

```
dart pub global activate flutterfire_cli
```

```
flutterfire configure
```

- secrets.dart örneği
```
class Secrets {
  static String webRecaptchaSiteKey =
      "6Ldxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx";
}
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
    ".read": false,
    ".write": false,
    "Users": {
      ".read": true,
      "$user_id": {
      	".read": true,
      	".write": "auth != null && auth.uid == $user_id"
    	},
    },
    "usernames": {
      ".read": true,
      ".write": "auth != null"
    }
  }
}
```