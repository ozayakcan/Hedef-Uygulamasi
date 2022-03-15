import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sosyal/utils/shared_pref.dart';

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
  runApp(
    const RestartApp(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool darkTheme = false;

  @override
  void initState() {
    super.initState();
    SharedPref.isDarkTheme().then((value) {
      setState(() {
        darkTheme = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (BuildContext context, snapshot1) {
        if (snapshot1.connectionState == ConnectionState.waiting) {
          return homeMaterialApp(
            const SplashScreen(),
            darkTheme,
          );
        } else {
          if (snapshot1.hasData) {
            return homeMaterialApp(
              HomePage(
                redirectEnabled: true,
                darkTheme: darkTheme,
              ),
              darkTheme,
            );
          } else {
            return homeMaterialApp(
              Login(
                redirectEnabled: true,
                darkTheme: darkTheme,
              ),
              darkTheme,
            );
          }
        }
      },
    );
  }
}

class RestartApp extends StatefulWidget {
  const RestartApp({required this.child});

  final Widget child;

  static void restartApp(BuildContext context) {
    context.findAncestorStateOfType<_RestartAppState>()!.restartApp();
  }

  @override
  _RestartAppState createState() => _RestartAppState();
}

class _RestartAppState extends State<RestartApp> {
  Key key = UniqueKey();

  void restartApp() {
    setState(() {
      key = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key: key,
      child: widget.child,
    );
  }
}
