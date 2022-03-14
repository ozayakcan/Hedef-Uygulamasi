import 'package:auth_buttons/auth_buttons.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:sosyal/widgets/text_fields.dart';

import '../utils/auth.dart';
import '../utils/colors.dart';
import '../utils/database.dart';
import '../utils/variables.dart';
import '../views/add.dart';
import '../views/home.dart';
import '../views/login.dart';
import 'widgets.dart';

AuthButtonStyle defaultAuthButtonStyle(double _width) {
  return AuthButtonStyle(
    width: _width,
    height: Variables.defaultButtonHeight,
    borderColor: ThemeColor.buttonBorder,
    splashColor: ThemeColor.buttonBorder,
  );
}

AuthButtonStyle primaryButtonStyle(double _width) {
  return AuthButtonStyle(
    width: _width,
    height: Variables.defaultButtonHeight,
    borderColor: ThemeColor.buttonBorder,
    splashColor: ThemeColor.buttonSplash,
    buttonColor: ThemeColor.buttonPrimary,
    textStyle: const TextStyle(color: ThemeColor.buttonText),
  );
}

AuthButtonStyle secondaryButtonStyle(double _width) {
  return AuthButtonStyle(
    width: _width,
    height: Variables.defaultButtonHeight,
    borderColor: ThemeColor.buttonBorder,
    splashColor: ThemeColor.buttonSplash,
    buttonColor: ThemeColor.buttonSecondary,
    textStyle: const TextStyle(color: ThemeColor.buttonText),
  );
}

GoogleAuthButton googleAuthBtn(BuildContext context, bool redirectEnabled) {
  return GoogleAuthButton(
    style: defaultAuthButtonStyle(MediaQuery.of(context).size.width),
    onPressed: () {
      try {
        if (kIsWeb) {
          Auth.signInWithGoogleWeb(context).then((value) {
            if (value == null) {
              if (!redirectEnabled) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomePage(
                      redirectEnabled: redirectEnabled,
                    ),
                  ),
                  (route) => false,
                );
              }
            } else {
              ScaffoldSnackbar.of(context).show(value);
            }
          });
        } else {
          Auth.signInWithGoogle(context).then((value) {
            if (value == null) {
              if (!redirectEnabled) {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomePage(
                      redirectEnabled: redirectEnabled,
                    ),
                  ),
                  (route) => false,
                );
              }
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

EmailAuthButton emailLoginBtn(BuildContext context, bool redirectEnabled) {
  return EmailAuthButton(
    style: defaultAuthButtonStyle(MediaQuery.of(context).size.width),
    onPressed: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EmailLogin(),
        ),
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
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => const HomePage(
                redirectEnabled: false,
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
) {
  return CustomAuthButton(
    iconUrl: "",
    style: secondaryButtonStyle(MediaQuery.of(context).size.width),
    onPressed: () {
      if (username.text.isNotEmpty && username.text.length >= 3) {
        if (usernameRegExp.hasMatch(username.text)) {
          Database.checkUsername(username.text).then((userNameValue) {
            if (userNameValue != null) {
              if (userNameValue == false) {
                if (name.text.isNotEmpty && name.text.length >= 3) {
                  if (password.text == passwordRp.text) {
                    Auth.signupWithEmail(
                            context, email.text, name.text, password.text)
                        .then((registerValue) {
                      if (registerValue == null) {
                        User? user = Auth.user;
                        Database.addUser(
                                user!.uid, email.text, username.text, name.text)
                            .then((value) {
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
                              builder: (context) => const HomePage(
                                redirectEnabled: false,
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
    BuildContext context, TextEditingController email) {
  return CustomAuthButton(
    iconUrl: "",
    style: secondaryButtonStyle(MediaQuery.of(context).size.width),
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

CustomAuthButton routeBtn(BuildContext context, Widget widget, String text) {
  return CustomAuthButton(
    iconUrl: "",
    style: secondaryButtonStyle(MediaQuery.of(context).size.width),
    onPressed: () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => widget),
      );
    },
    text: text,
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

class AddButton extends StatelessWidget {
  const AddButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(HeroDialogRoute(builder: (context) {
            return const AddPage();
          }));
        },
        child: Hero(
          tag: Variables.heroAddTag,
          createRectTween: (begin, end) {
            return CustomRectTween(begin: begin, end: end);
          },
          child: Material(
            color: ThemeColor.buttonSecondary,
            elevation: 2,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
            child: const Icon(
              Icons.add_rounded,
              size: 56,
              color: ThemeColor.buttonText,
            ),
          ),
        ),
      ),
    );
  }
}
