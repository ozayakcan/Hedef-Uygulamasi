import 'package:auth_buttons/auth_buttons.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hedef/utils/auth.dart';
import 'package:hedef/utils/colors.dart';
import 'package:hedef/utils/variables.dart';
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
      style: simpleTextStyleWhite(mediumFontSize),
    ),
  );
}

DefaultTabController defaultTabController(BuildContext context,
    List<Widget> tabList, List<Widget> tabContentList, List<Widget> menu) {
  return DefaultTabController(
    length: 2,
    child: Scaffold(
      appBar: AppBar(
        title: appBarTitle(AppLocalizations.of(context).app_name),
        actions: menu,
        bottom: TabBar(
          labelStyle: titilliumWebTextStyle(
            Colors.white,
            normalFontSize,
          ),
          unselectedLabelStyle: titilliumWebTextStyle(
            Colors.white70,
            normalFontSize,
          ),
          tabs: tabList,
        ),
      ),
      body: TabBarView(
        children: tabContentList,
      ),
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

TextStyle titilliumWebTextStyle(Color color, double _fontSize) {
  return TextStyle(
    color: color,
    fontSize: _fontSize,
    fontFamily: "TitilliumWeb",
  );
}

TextStyle simpleTextStyle(double _fontSize) {
  return TextStyle(
    color: Colors.black87,
    fontSize: _fontSize,
  );
}

TextStyle simpleTextStyleWhite(double _fontSize) {
  return TextStyle(
    color: Colors.white,
    fontSize: _fontSize,
  );
}

TextStyle linktTextStyle(double _fonstSize) {
  return TextStyle(
    color: MyColors.colorPrimary,
    fontSize: _fonstSize,
  );
}

double normalFontSize = 16;
double mediumFontSize = 17;
double bigFontSize = 18;
//Giriş Sayfası
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

EmailAuthButton emailLoginBtn(BuildContext context) {
  return EmailAuthButton(
    style: defaultAuthButtonStyle(MediaQuery.of(context).size.width),
    onPressed: () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => EmailLogin()),
      );
    },
    text: AppLocalizations.of(context).login_with_email,
  );
}

CustomAuthButton loginBtn(BuildContext context, TextEditingController email,
    TextEditingController password) {
  return CustomAuthButton(
    iconUrl: "",
    style: primaryButtonStyle(MediaQuery.of(context).size.width),
    onPressed: () {
      Auth.signInWithEmail(context, email.text, password.text).then((value) {
        if (value == null) {
          Navigator.pop(context);
        } else {
          ScaffoldSnackbar.of(context).show(value);
        }
      });
    },
    text: AppLocalizations.of(context).login,
  );
}

CustomAuthButton registerRtBtn(BuildContext context) {
  return CustomAuthButton(
    iconUrl: "",
    style: secondaryButtonStyle(MediaQuery.of(context).size.width),
    onPressed: () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => EmailRegister()),
      );
    },
    text: AppLocalizations.of(context).register,
  );
}

CustomAuthButton registerBtn(BuildContext context, TextEditingController email,
    TextEditingController password, TextEditingController passwordRp) {
  return CustomAuthButton(
    iconUrl: "",
    style: secondaryButtonStyle(MediaQuery.of(context).size.width),
    onPressed: () {
      if (password.text == passwordRp.text) {
        Auth.signupWithEmail(context, email.text, password.text).then((value) {
          if (value == null) {
            Navigator.pop(context);
          } else {
            ScaffoldSnackbar.of(context).show(value);
          }
        });
      } else {
        ScaffoldSnackbar.of(context)
            .show(AppLocalizations.of(context).passwords_do_not_match);
      }
    },
    text: AppLocalizations.of(context).register,
  );
}

CustomAuthButton backBtn(BuildContext context, {VoidCallback? action}) {
  return CustomAuthButton(
    iconUrl: "",
    style: defaultAuthButtonStyle(MediaQuery.of(context).size.width),
    onPressed: () {
      if (action == null) {
        Navigator.pop(context);
      } else {
        action();
      }
    },
    text: AppLocalizations.of(context).back,
  );
}

TextField emailTextField(
    {required BuildContext context,
    required TextEditingController emailController,
    CustomAuthButton? authButton,
    FocusNode? passwordFocus}) {
  return TextField(
    controller: emailController,
    keyboardType: TextInputType.emailAddress,
    textInputAction:
        passwordFocus != null ? TextInputAction.next : TextInputAction.done,
    decoration: InputDecoration(
      labelText: AppLocalizations.of(context).email,
      labelStyle: const TextStyle(
        color: MyColors.colorPrimary,
      ),
    ),
    onSubmitted: (v) {
      if (authButton != null) {
        authButton.onPressed!();
        return;
      }
      if (passwordFocus != null) {
        FocusScope.of(context).requestFocus(passwordFocus);
        return;
      }
    },
  );
}

TextField passwordTextField(
    {required BuildContext context,
    required String pwtext,
    required TextEditingController passwordController,
    CustomAuthButton? authButton,
    FocusNode? passwordFocus,
    FocusNode? passwordRpFocus}) {
  return TextField(
    controller: passwordController,
    focusNode: passwordFocus,
    obscureText: true,
    enableSuggestions: false,
    autocorrect: false,
    textInputAction:
        passwordRpFocus != null ? TextInputAction.next : TextInputAction.done,
    decoration: InputDecoration(
      labelText: pwtext,
      labelStyle: const TextStyle(
        color: MyColors.colorPrimary,
      ),
    ),
    onSubmitted: (v) {
      if (authButton != null) {
        authButton.onPressed!();
        return;
      }
      if (passwordRpFocus != null) {
        FocusScope.of(context).requestFocus(passwordRpFocus);
        return;
      }
    },
  );
}
