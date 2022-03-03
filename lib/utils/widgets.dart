import 'package:auth_buttons/auth_buttons.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hedef/utils/auth.dart';
import 'package:hedef/utils/colors.dart';
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

GoogleAuthButton googleAuthBtn(BuildContext context) {
  return GoogleAuthButton(
    style: AuthButtonStyle(
      width: MediaQuery.of(context).size.width,
      height: Variables.defaultButtonHeight,
      borderColor: Colors.black,
    ),
    onPressed: () {
      try {
        if (kIsWeb) {
          Auth.signInWithGoogleWeb();
        } else {
          Auth.signInWithGoogle();
        }
      } on FirebaseAuthException catch (e) {
        if (kDebugMode) {
          print('Giriş Başarısız! Kod: ${e.code}');
          print(e.message);
        }
      }
    },
    text: "Google ile Giriş Yap",
  );
}

ElevatedButton emailSignInBtn(void Function() _onPressed) {
  return ElevatedButton(
    style: ElevatedButton.styleFrom(
      minimumSize: Size.fromHeight(Variables.defaultButtonHeight),
      primary: MyColors.colorPrimary,
      padding: EdgeInsets.all(Variables.defaultButtonPadding),
      side: BorderSide(
        color: Colors.black54,
        width: Variables.defaultButtonBorderSize,
      ),
    ),
    onPressed: _onPressed,
    child: const Text(
      "Eposta ile Giriş Yap",
      style: TextStyle(color: Colors.white),
    ),
  );
}
