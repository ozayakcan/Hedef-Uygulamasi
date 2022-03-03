import 'package:auth_buttons/auth_buttons.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hedef/utils/auth.dart';
import 'package:hedef/utils/colors.dart';
import 'package:hedef/utils/errors.dart';
import 'package:hedef/utils/variables.dart';

MaterialApp homeMaterialApp(Widget page) {
  return MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      scaffoldBackgroundColor: Colors.white,
      primarySwatch: MyColors.colorPrimary,
      visualDensity: VisualDensity.adaptivePlatformDensity,
    ),
    title: "Hedef",
    home: page,
  );
}

PreferredSizeWidget appBarMain(String title) {
  return AppBar(
    title: appBarTitle(
      title,
    ),
  );
}

Container appBarTitle(String title) {
  return Container(
    margin: const EdgeInsets.only(left: 10),
    child: Text(
      title,
      style: mediumTextStyleWhite(),
    ),
  );
}

class ScaffoldSnackbar {
  ScaffoldSnackbar(this._context);
  final BuildContext _context;

  factory ScaffoldSnackbar.of(BuildContext context) {
    return ScaffoldSnackbar(context);
  }
  void show(String message) {
    ScaffoldMessenger.of(_context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(message)),
      );
  }
}

TextStyle simpleTextStyle() {
  return const TextStyle(
    color: Colors.black87,
    fontSize: 16,
  );
}

TextStyle mediumTextStyle() {
  return const TextStyle(
    color: Colors.black87,
    fontSize: 17,
  );
}

TextStyle mediumTextStyleWhite() {
  return const TextStyle(
    color: Colors.white,
    fontSize: 17,
  );
}

AuthButtonStyle defaultAuthButtonStyle(double _width) {
  return AuthButtonStyle(
    width: _width,
    height: Variables.defaultButtonHeight,
    borderColor: Colors.black,
  );
}

GoogleAuthButton googleAuthBtn(BuildContext context) {
  return GoogleAuthButton(
    style: defaultAuthButtonStyle(MediaQuery.of(context).size.width),
    onPressed: () {
      try {
        if (kIsWeb) {
          Auth.signInWithGoogleWeb();
        } else {
          Auth.signInWithGoogle();
        }
      } on FirebaseAuthException catch (e) {
        loginError(context, e);
      }
    },
    text: "Google ile Giriş Yap",
  );
}

EmailAuthButton emailAuthBtn(BuildContext context) {
  return EmailAuthButton(
    style: defaultAuthButtonStyle(MediaQuery.of(context).size.width),
    onPressed: () {
      try {
        if (kIsWeb) {
          Auth.signInWithGoogleWeb();
        } else {
          Auth.signInWithGoogle();
        }
      } on FirebaseAuthException catch (e) {
        loginError(context, e);
      }
    },
    text: "Eposta ile Giriş Yap",
  );
}
