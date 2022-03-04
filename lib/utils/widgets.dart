import 'package:auth_buttons/auth_buttons.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hedef/utils/auth.dart';
import 'package:hedef/utils/colors.dart';
import 'package:hedef/utils/errors.dart';
import 'package:hedef/utils/variables.dart';
import 'package:hedef/views/login.dart';

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
    toolbarHeight: 50,
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

//Giriş Butonları
AuthButtonStyle defaultAuthButtonStyle(double _width) {
  return AuthButtonStyle(
    width: _width,
    height: Variables.defaultButtonHeight,
    borderColor: MyColors.defaultBtnBorderColor,
    splashColor: MyColors.defaultBtnSplashColor,
  );
}

AuthButtonStyle primaryButtonStyle(double _width) {
  return AuthButtonStyle(
    width: _width,
    height: Variables.defaultButtonHeight,
    borderColor: MyColors.defaultBtnBorderColor,
    splashColor: MyColors.defaultBtnSplashColor,
    buttonColor: MyColors.colorPrimary,
    textStyle: const TextStyle(color: Colors.white),
  );
}

AuthButtonStyle secondaryButtonStyle(double _width) {
  return AuthButtonStyle(
    width: _width,
    height: Variables.defaultButtonHeight,
    borderColor: MyColors.defaultBtnBorderColor,
    splashColor: MyColors.defaultBtnSplashColor,
    buttonColor: MyColors.colorSecondary,
    textStyle: const TextStyle(color: Colors.white),
  );
}

GoogleAuthButton googleAuthBtn(BuildContext context) {
  return GoogleAuthButton(
    style: defaultAuthButtonStyle(MediaQuery.of(context).size.width),
    onPressed: () {
      try {
        try {
          if (kIsWeb) {
            Auth.signInWithGoogleWeb();
          } else {
            Auth.signInWithGoogle();
          }
        } on PlatformException catch (e) {
          loginError2(context, e);
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
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => EmailAuth()),
      );
    },
    text: "Eposta ile Giriş Yap",
  );
}

CustomAuthButton signinBtn(BuildContext context, TextEditingController email,
    TextEditingController password) {
  return CustomAuthButton(
    iconUrl: "",
    style: primaryButtonStyle(MediaQuery.of(context).size.width),
    onPressed: () {
      Auth.signInWithEmail(email.text, password.text).then((value) {
        if (value == null) {
        } else {
          ScaffoldSnackbar.of(context).show(value);
        }
      });
    },
    text: "Giriş Yap",
  );
}

CustomAuthButton signupBtn(BuildContext context, TextEditingController email,
    TextEditingController password) {
  return CustomAuthButton(
    iconUrl: "",
    style: secondaryButtonStyle(MediaQuery.of(context).size.width),
    onPressed: () {
      Auth.signupWithEmail(email.text, password.text).then((value) {
        if (value == null) {
          ScaffoldSnackbar.of(context)
              .show("Başarıyla kaydoldunuz! Şimdi giriş yapabilirsiniz!");
        } else {
          ScaffoldSnackbar.of(context).show(value);
        }
      });
    },
    text: "Kaydol",
  );
}

CustomAuthButton backBtn(BuildContext context) {
  return CustomAuthButton(
    iconUrl: "",
    style: defaultAuthButtonStyle(MediaQuery.of(context).size.width),
    onPressed: () {
      Navigator.pop(context);
    },
    text: "Geri",
  );
}
