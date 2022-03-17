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
flutter.versionName=1.0.0
flutter.versionCode=1
flutter.minSdkVersion=19
```

- key.properties örneği
```
releaseStorePassword=sifre
releaseKeyPassword=sifre
releaseKeyAlias=release
releaseStoreFile=../key/keystore.jks
#Konum android/key/keystore.jks
debugStorePassword=android
debugKeyPassword=android
debugKeyAlias=androiddebugkey
debugStoreFile=C:\\Users\\Proje\\\.android\\debug.keystore
#Konum C > Kullanıcılar > Kullanıcı Dosyası > .android > debug.keystore
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