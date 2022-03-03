import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hedef/firebase_options.dart';
import 'package:hedef/secrets.dart';
import 'package:hedef/utils/widgets.dart';
import 'package:hedef/views/home.dart';
import 'package:hedef/views/login.dart';
import 'package:hedef/views/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseAppCheck.instance.activate(
    webRecaptchaSiteKey: Secrets.webRecaptchaSiteKey,
  );
  await FirebaseAppCheck.instance.setTokenAutoRefreshEnabled(true);
  FirebaseAppCheck.instance.onTokenChange.listen((token) {
    if (kDebugMode) {
      print("Token değişti. Yeni token: " + token!);
    }
  });
  if (kIsWeb) {
    await FirebaseAuth.instance.setPersistence(Persistence.LOCAL);
  }
  FirebaseAuth.instance.authStateChanges().listen((User? user) {
    if (kDebugMode) {
      if (user == null) {
        print('Kullanıcı giriş yapmadı!');
      } else {
        print('Kullanıcı giriş yaptı!');
      }
    }
  });
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (BuildContext context, snapshot1) {
        if (snapshot1.connectionState == ConnectionState.waiting) {
          if (kIsWeb) {
            return homeMaterialApp(const SplashScreen());
          } else {
            return homeMaterialApp(SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
            ));
          }
        } else {
          if (snapshot1.hasData) {
            return homeMaterialApp(const HomePage());
          } else {
            return homeMaterialApp(const Login());
          }
        }
      },
    );
  }
}
