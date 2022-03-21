import 'package:auth_buttons/auth_buttons.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../models/user.dart';
import '../utils/auth.dart';
import '../utils/colors.dart';
import '../utils/database/database.dart';
import '../utils/database/user_database.dart';
import '../utils/assets.dart';
import '../utils/variables.dart';
import '../views/home.dart';
import '../views/login.dart';
import 'text_fields.dart';
import 'widgets.dart';

AuthButtonStyle defaultAuthButtonStyle(
  double width,
  bool darkTheme, {
  double? borderRadius,
  double iconSize = Variables.buttonIconSizeDefault,
}) {
  return AuthButtonStyle(
    borderRadius: borderRadius ?? Variables.buttonRadiusDefault,
    width: width,
    height: Variables.buttonHeightDefault,
    iconSize: iconSize,
    borderColor:
        darkTheme ? ThemeColorDark.buttonBorder : ThemeColor.buttonBorder,
    splashColor:
        darkTheme ? ThemeColorDark.buttonSplash : ThemeColor.buttonSplash,
  );
}

AuthButtonStyle primaryButtonStyle(
  double width,
  bool darkTheme, {
  double? borderRadius,
  double iconSize = Variables.buttonIconSizeDefault,
}) {
  return AuthButtonStyle(
    borderRadius: borderRadius ?? Variables.buttonRadiusDefault,
    width: width,
    height: Variables.buttonHeightDefault,
    iconSize: iconSize,
    borderColor:
        darkTheme ? ThemeColorDark.buttonBorder : ThemeColor.buttonBorder,
    splashColor:
        darkTheme ? ThemeColorDark.buttonSplash : ThemeColor.buttonSplash,
    buttonColor:
        darkTheme ? ThemeColorDark.buttonPrimary : ThemeColor.buttonPrimary,
    textStyle: TextStyle(
        color: darkTheme ? ThemeColorDark.buttonText : ThemeColor.buttonText),
  );
}

AuthButtonStyle secondaryButtonStyle(
  double width,
  bool darkTheme, {
  double? borderRadius,
  double iconSize = Variables.buttonIconSizeDefault,
}) {
  return AuthButtonStyle(
    borderRadius: borderRadius ?? Variables.buttonRadiusDefault,
    width: width,
    height: Variables.buttonHeightDefault,
    iconSize: iconSize,
    borderColor:
        darkTheme ? ThemeColorDark.buttonBorder : ThemeColor.buttonBorder,
    splashColor:
        darkTheme ? ThemeColorDark.buttonSplash : ThemeColor.buttonSplash,
    buttonColor:
        darkTheme ? ThemeColorDark.buttonSecondary : ThemeColor.buttonSecondary,
    textStyle: TextStyle(
        color: darkTheme ? ThemeColorDark.buttonText : ThemeColor.buttonText),
  );
}

GoogleAuthButton googleAuthBtn(BuildContext context, bool darkTheme) {
  return GoogleAuthButton(
    style: defaultAuthButtonStyle(MediaQuery.of(context).size.width, darkTheme),
    darkMode: darkTheme,
    onPressed: () {
      try {
        if (kIsWeb) {
          Auth.signInWithGoogleWeb(context).then((value) {
            if (value == null) {
              UserDB.addGoogleUser();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => HomePage(
                    darkTheme: darkTheme,
                  ),
                ),
                (route) => false,
              );
            } else {
              ScaffoldSnackbar.of(context).show(value);
            }
          });
        } else {
          Auth.signInWithGoogle(context).then((value) {
            if (value == null) {
              UserDB.addGoogleUser();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => HomePage(
                    darkTheme: darkTheme,
                  ),
                ),
                (route) => false,
              );
            } else {
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

EmailAuthButton emailLoginBtn(BuildContext context, bool darkTheme) {
  return EmailAuthButton(
    style: defaultAuthButtonStyle(MediaQuery.of(context).size.width, darkTheme),
    darkMode: darkTheme,
    onPressed: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EmailLogin(
            darkTheme: darkTheme,
          ),
        ),
      );
    },
    text: AppLocalizations.of(context).login_with_email,
  );
}

CustomAuthButton loginBtn(
  BuildContext context,
  TextEditingController email,
  TextEditingController password,
  bool darkTheme,
) {
  return CustomAuthButton(
    iconUrl: AImages.empty,
    style: primaryButtonStyle(MediaQuery.of(context).size.width, darkTheme),
    darkMode: darkTheme,
    onPressed: () {
      Auth.signInWithEmail(context, email.text, password.text).then((value) {
        if (value == null) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => HomePage(
                darkTheme: darkTheme,
              ),
            ),
            (route) => false,
          );
        } else {
          ScaffoldSnackbar.of(context).show(value);
        }
      });
    },
    text: AppLocalizations.of(context).login,
  );
}

CustomAuthButton registerBtn(
  BuildContext context,
  TextEditingController email,
  TextEditingController username,
  TextEditingController name,
  TextEditingController password,
  TextEditingController passwordRp,
  bool darkTheme,
) {
  return CustomAuthButton(
    iconUrl: AImages.empty,
    style: secondaryButtonStyle(MediaQuery.of(context).size.width, darkTheme),
    darkMode: darkTheme,
    onPressed: () {
      if (username.text.isNotEmpty && username.text.length >= 3) {
        if (usernameRegExp.hasMatch(username.text)) {
          UserDB.checkUsername(username.text).then((userNameValue) {
            if (userNameValue != null) {
              if (userNameValue == false) {
                if (name.text.isNotEmpty && name.text.length >= 3) {
                  if (password.text == passwordRp.text) {
                    Auth.signupWithEmail(
                            context, email.text, name.text, password.text)
                        .then((registerValue) {
                      if (registerValue == null) {
                        User? user = Auth.user;
                        UserModel userModel = UserModel(
                          user!.uid,
                          email.text,
                          username.text,
                          name.text,
                          DateTime.now(),
                          Database.defaultValue,
                        );
                        UserDB.addUser(userModel).then((value) {
                          Auth.sendEmailVerification(context)
                              .then((emailVerificationValue) {
                            if (emailVerificationValue == null) {
                              if (kDebugMode) {
                                print("Eposta onayı gönderildi.");
                              }
                            } else {
                              if (kDebugMode) {
                                print("Eposta gönderilemedi. Hata: " +
                                    emailVerificationValue);
                              }
                            }
                          });
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HomePage(
                                darkTheme: darkTheme,
                              ),
                            ),
                            (route) => false,
                          );
                        });
                      } else {
                        ScaffoldSnackbar.of(context).show(registerValue);
                      }
                    });
                  } else {
                    ScaffoldSnackbar.of(context).show(
                        AppLocalizations.of(context).passwords_do_not_match);
                  }
                } else {
                  ScaffoldSnackbar.of(context)
                      .show(AppLocalizations.of(context).name_must_3_character);
                }
              } else {
                ScaffoldSnackbar.of(context)
                    .show(AppLocalizations.of(context).username_already_exists);
              }
            } else {
              ScaffoldSnackbar.of(context)
                  .show(AppLocalizations.of(context).an_error_occurred);
            }
          });
        } else {
          ScaffoldSnackbar.of(context)
              .show(AppLocalizations.of(context).username_regmatch_error);
        }
      } else {
        ScaffoldSnackbar.of(context)
            .show(AppLocalizations.of(context).username_must_3_character);
      }
    },
    text: AppLocalizations.of(context).register,
  );
}

CustomAuthButton resetPasswordBtn(
    BuildContext context, TextEditingController email, bool darkTheme) {
  return CustomAuthButton(
    iconUrl: AImages.empty,
    style: secondaryButtonStyle(MediaQuery.of(context).size.width, darkTheme),
    darkMode: darkTheme,
    onPressed: () {
      Auth.resetPassword(context, email.text).then((value) {
        if (value == null) {
          ScaffoldSnackbar.of(context)
              .show(AppLocalizations.of(context).reset_password_link_sent);
          email.text = "";
        } else {
          ScaffoldSnackbar.of(context).show(value);
        }
      });
    },
    text: AppLocalizations.of(context).reset_password,
  );
}

CustomAuthButton routeBtn(
    BuildContext context, Widget widget, String text, bool darkTheme) {
  return CustomAuthButton(
    iconUrl: AImages.empty,
    style: secondaryButtonStyle(MediaQuery.of(context).size.width, darkTheme),
    darkMode: darkTheme,
    onPressed: () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => widget),
      );
    },
    text: text,
  );
}

CustomAuthButton backBtn(BuildContext context, bool darkTheme,
    {VoidCallback? action}) {
  return CustomAuthButton(
    iconUrl: AImages.empty,
    style: defaultAuthButtonStyle(MediaQuery.of(context).size.width, darkTheme),
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

CustomAuthButton customButton(
  BuildContext context, {
  required String text,
  required ButtonStyleEnum buttonStyle,
  required bool darkTheme,
  double? width,
  double? borderRadius,
  String iconUrl = AImages.empty,
  VoidCallback? action,
}) {
  return CustomAuthButton(
    iconUrl: iconUrl,
    style: buttonStyle == ButtonStyleEnum.primaryButton
        ? primaryButtonStyle(
            width ?? MediaQuery.of(context).size.width,
            darkTheme,
            borderRadius: borderRadius,
            iconSize: Variables.buttonIconSizeSmall,
          )
        : buttonStyle == ButtonStyleEnum.secondaryButton
            ? secondaryButtonStyle(
                width ?? MediaQuery.of(context).size.width,
                darkTheme,
                borderRadius: borderRadius,
                iconSize: Variables.buttonIconSizeSmall,
              )
            : defaultAuthButtonStyle(
                width ?? MediaQuery.of(context).size.width,
                darkTheme,
                borderRadius: borderRadius,
                iconSize: Variables.buttonIconSizeSmall,
              ),
    onPressed: () {
      if (action != null) {
        action();
      }
    },
    text: text,
  );
}

enum ButtonStyleEnum {
  defaultButton,
  primaryButton,
  secondaryButton,
}
