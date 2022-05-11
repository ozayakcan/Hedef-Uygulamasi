import 'dart:async';

import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';
import 'secrets.dart';
import 'utils/shared_pref.dart';
import 'views/home.dart';
import 'views/language.dart';
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
  /*FirebaseAppCheck.instance.onTokenChange.listen((token) {
    if (kDebugMode) {
      print("Token değişti. Yeni token: " + token!);
    }
  });*/
  if (kIsWeb) {
    await FirebaseAuth.instance.setPersistence(Persistence.LOCAL);
  }
  runApp(
    const RestartAppWidget(
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
  Locale locale = Locale(getLanguageCode());
  bool darkTheme = false;

  FirebaseAuth auth = FirebaseAuth.instance;
  bool? isLogged;
  StreamSubscription<User?>? firebaseAuthEvent;
  @override
  void initState() {
    super.initState();
    SharedPref.getLocale().then((value) {
      setState(() {
        locale = Locale(value);
      });
    });
    SharedPref.isDarkTheme().then((value) {
      setState(() {
        darkTheme = value;
      });
    });
    firebaseAuthEvent =
        FirebaseAuth.instance.authStateChanges().listen((event) {
      if (isLogged == null) {
        if (event != null) {
          setState(() {
            isLogged = true;
          });
        } else {
          setState(() {
            isLogged = false;
          });
        }
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    firebaseAuthEvent?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    if (isLogged != null) {
      if (isLogged!) {
        return homeMaterialApp(
          HomePage(
            darkTheme: darkTheme,
          ),
          locale,
          darkTheme,
        );
      } else {
        return homeMaterialApp(
          Login(
            darkTheme: darkTheme,
          ),
          locale,
          darkTheme,
        );
      }
    } else {
      return homeMaterialApp(
        SplashScreen(
          darkTheme: darkTheme,
        ),
        locale,
        darkTheme,
      );
    }
    /*return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (BuildContext context, snapshot1) {
        if (snapshot1.connectionState == ConnectionState.waiting) {
          return homeMaterialApp(
            const SplashScreen(),
            locale,
            darkTheme,
          );
        } else {
          if (snapshot1.hasData) {
            return homeMaterialApp(
              HomePage(
                darkTheme: darkTheme,
              ),
              locale,
              darkTheme,
            );
          } else {
            return homeMaterialApp(
              Login(
                darkTheme: darkTheme,
              ),
              locale,
              darkTheme,
            );
          }
        }
      },
    );*/
  }
}

class RestartAppWidget extends StatefulWidget {
  // ignore: use_key_in_widget_constructors
  const RestartAppWidget({required this.child});

  final Widget child;

  static void restartApp(BuildContext context) {
    context.findAncestorStateOfType<_RestartAppWidgetState>()!.restartApp();
  }

  @override
  _RestartAppWidgetState createState() => _RestartAppWidgetState();
}

class _RestartAppWidgetState extends State<RestartAppWidget> {
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
