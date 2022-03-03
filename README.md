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
flutter.minSdkVersion=19
flutter.targetSdkVersion=32
flutter.compileSdkVersion=32
flutter.versionCode=1
```