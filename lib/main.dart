import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';
import 'secrets.dart';
import 'views/home.dart';
import 'views/login.dart';
import 'views/splash_screen.dart';
import 'widgets/page_style.dart';

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
          return homeMaterialApp(const SplashScreen());
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
