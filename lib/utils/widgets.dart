import 'package:auth_buttons/auth_buttons.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hedef/utils/auth.dart';
import 'package:hedef/utils/colors.dart';
import 'package:hedef/utils/variables.dart';
import 'package:hedef/views/home.dart';
import 'package:hedef/views/login.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

MaterialApp homeMaterialApp(Widget page) {
  return MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      scaffoldBackgroundColor: Colors.white,
      primarySwatch: MyColors.colorPrimary,
      visualDensity: VisualDensity.adaptivePlatformDensity,
    ),
    localizationsDelegates: const [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
    ],
    supportedLocales: AppLocalizations.supportedLocales,
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
        if (kIsWeb) {
          Auth.signInWithGoogleWeb(context).then((value) {
            if (value != null) {
              ScaffoldSnackbar.of(context).show(value);
            }
          });
        } else {
          Auth.signInWithGoogle(context).then((value) {
            if (value != null) {
              ScaffoldSnackbar.of(context).show(value);
            }
          });
        }
      } on PlatformException catch (e) {
        if (kDebugMode) {
          print(e.message);
        }
      }
    },
    text: AppLocalizations.of(context).login_with_google,
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
    text: AppLocalizations.of(context).login_with_email,
  );
}

CustomAuthButton signinBtn(BuildContext context, TextEditingController email,
    TextEditingController password) {
  return CustomAuthButton(
    iconUrl: "",
    style: primaryButtonStyle(MediaQuery.of(context).size.width),
    onPressed: () {
      Auth.signInWithEmail(context, email.text, password.text).then((value) {
        if (value == null) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomePage()),
          );
        } else {
          ScaffoldSnackbar.of(context).show(value);
        }
      });
    },
    text: AppLocalizations.of(context).login,
  );
}

CustomAuthButton signupBtn(BuildContext context, TextEditingController email,
    TextEditingController password) {
  return CustomAuthButton(
    iconUrl: "",
    style: secondaryButtonStyle(MediaQuery.of(context).size.width),
    onPressed: () {
      Auth.signupWithEmail(context, email.text, password.text).then((value) {
        if (value == null) {
          ScaffoldSnackbar.of(context)
              .show(AppLocalizations.of(context).register_success);
        } else {
          ScaffoldSnackbar.of(context).show(value);
        }
      });
    },
    text: AppLocalizations.of(context).register,
  );
}

CustomAuthButton backBtn(BuildContext context) {
  return CustomAuthButton(
    iconUrl: "",
    style: defaultAuthButtonStyle(MediaQuery.of(context).size.width),
    onPressed: () {
      Navigator.pop(context);
    },
    text: AppLocalizations.of(context).back,
  );
}
