import 'package:auth_buttons/auth_buttons.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../firebase/auth.dart';
import '../firebase/database/database.dart';
import '../firebase/database/user_database.dart';
import '../models/user.dart';
import '../utils/assets.dart';
import '../utils/theme_colors.dart';
import '../utils/time.dart';
import '../utils/variables.dart';
import '../views/home.dart';
import '../views/login.dart';
import '../views/share.dart';
import 'texts.dart';
import 'widgets.dart';

AuthButtonStyle defaultAuthButtonStyle({
  required bool darkTheme,
  required double? width,
  required double? height,
  double? borderRadius,
  EdgeInsets? padding,
  double iconSize = Variables.buttonIconSizeDefault,
}) {
  return AuthButtonStyle(
    borderRadius: borderRadius ?? Variables.buttonRadiusDefault,
    padding: padding,
    width: width,
    height: height,
    iconSize: iconSize,
    borderColor: ThemeColor.of(darkTheme).buttonBorder,
    splashColor: ThemeColor.of(darkTheme).buttonSplash,
  );
}

AuthButtonStyle primaryButtonStyle({
  required bool darkTheme,
  required double? width,
  required double? height,
  double? borderRadius,
  EdgeInsets? padding,
  double iconSize = Variables.buttonIconSizeDefault,
}) {
  return AuthButtonStyle(
    borderRadius: borderRadius ?? Variables.buttonRadiusDefault,
    padding: padding,
    width: width,
    height: height,
    iconSize: iconSize,
    borderColor: ThemeColor.of(darkTheme).buttonBorder,
    splashColor: ThemeColor.of(darkTheme).buttonSplash,
    buttonColor: ThemeColor.of(darkTheme).buttonPrimary,
    textStyle: TextStyle(
      color: ThemeColor.of(darkTheme).buttonText,
    ),
  );
}

AuthButtonStyle secondaryButtonStyle({
  required bool darkTheme,
  required double? width,
  required double? height,
  double? borderRadius,
  EdgeInsets? padding,
  double iconSize = Variables.buttonIconSizeDefault,
}) {
  return AuthButtonStyle(
    borderRadius: borderRadius ?? Variables.buttonRadiusDefault,
    padding: padding,
    width: width,
    height: height,
    iconSize: iconSize,
    borderColor: ThemeColor.of(darkTheme).buttonBorder,
    splashColor: ThemeColor.of(darkTheme).buttonSplash,
    buttonColor: ThemeColor.of(darkTheme).buttonSecondary,
    textStyle: TextStyle(
      color: ThemeColor.of(darkTheme).buttonText,
    ),
  );
}

GoogleAuthButton googleAuthBtn(
  BuildContext context,
  bool darkTheme, {
  double? width,
  double height = Variables.buttonHeightDefault,
}) {
  return GoogleAuthButton(
    style: defaultAuthButtonStyle(
        width: width ?? MediaQuery.of(context).size.width,
        height: height,
        darkTheme: darkTheme),
    darkMode: darkTheme,
    onPressed: () {
      try {
        if (kIsWeb) {
          Auth.of().signInWithGoogleWeb(context).then((value) {
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
          Auth.of().signInWithGoogle(context).then((value) {
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

EmailAuthButton emailLoginBtn(
  BuildContext context,
  bool darkTheme, {
  double? width,
  double height = Variables.buttonHeightDefault,
}) {
  return EmailAuthButton(
    style: defaultAuthButtonStyle(
        width: width ?? MediaQuery.of(context).size.width,
        height: height,
        darkTheme: darkTheme),
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
  bool darkTheme, {
  double? width,
  double height = Variables.buttonHeightDefault,
  VoidCallback? beforeLogin,
  VoidCallback? onResponse,
}) {
  return CustomAuthButton(
    iconUrl: AImages.empty,
    style: primaryButtonStyle(
        width: width ?? MediaQuery.of(context).size.width,
        height: height,
        darkTheme: darkTheme),
    darkMode: darkTheme,
    onPressed: () {
      beforeLogin?.call();
      Auth.of()
          .signInWithEmail(context, email.text, password.text)
          .then((value) {
        onResponse?.call();
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
  bool darkTheme, {
  double? width,
  double height = Variables.buttonHeightDefault,
  VoidCallback? beforeRegister,
  VoidCallback? onResponse,
}) {
  return CustomAuthButton(
    iconUrl: AImages.empty,
    style: secondaryButtonStyle(
      width: width ?? MediaQuery.of(context).size.width,
      height: height,
      darkTheme: darkTheme,
    ),
    darkMode: darkTheme,
    onPressed: () {
      beforeRegister?.call();
      UserDB.checkUsername(context, username.text).then((userNameValue) {
        if (userNameValue == true) {
          if (name.text.isNotEmpty && name.text.length >= 3) {
            if (password.text == passwordRp.text) {
              Auth.of()
                  .signupWithEmail(
                      context, email.text, name.text, password.text)
                  .then((registerValue) {
                if (registerValue == null) {
                  User user = Auth.of().user;
                  UserModel userModel = UserModel(
                    user.uid,
                    email.text,
                    username.text,
                    name.text,
                    Time.getTimeUtc(),
                    Database.defaultValue,
                  );
                  UserDB.addUser(userModel).then((value) {
                    Auth.of()
                        .sendEmailVerification(context)
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
                    onResponse?.call();
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
                  onResponse?.call();
                  ScaffoldSnackbar.of(context).show(registerValue);
                }
              });
            } else {
              onResponse?.call();
              ScaffoldSnackbar.of(context)
                  .show(AppLocalizations.of(context).passwords_do_not_match);
            }
          } else {
            onResponse?.call();
            ScaffoldSnackbar.of(context)
                .show(AppLocalizations.of(context).name_must_3_character);
          }
        }
      });
    },
    text: AppLocalizations.of(context).register,
  );
}

CustomAuthButton resetPasswordBtn(
  BuildContext context,
  TextEditingController email,
  bool darkTheme, {
  double? width,
  double height = Variables.buttonHeightDefault,
  VoidCallback? beforeResetPw,
  VoidCallback? onResponse,
}) {
  return CustomAuthButton(
    iconUrl: AImages.empty,
    style: secondaryButtonStyle(
      width: width ?? MediaQuery.of(context).size.width,
      height: height,
      darkTheme: darkTheme,
    ),
    darkMode: darkTheme,
    onPressed: () {
      beforeResetPw?.call();
      Auth.of().resetPassword(context, email.text).then((value) {
        onResponse?.call();
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
  BuildContext context,
  Widget widget,
  String text,
  bool darkTheme, {
  double? width,
  double height = Variables.buttonHeightDefault,
}) {
  return CustomAuthButton(
    iconUrl: AImages.empty,
    style: secondaryButtonStyle(
      width: width ?? MediaQuery.of(context).size.width,
      height: height,
      darkTheme: darkTheme,
    ),
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

Widget linkButton(
  BuildContext context,
  Widget widget,
  String text, {
  required bool darkTheme,
  bool replacement = false,
  double fontSiza = Variables.fontSizeNormal,
}) {
  return InkWell(
    onTap: () {
      if (replacement) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => widget,
          ),
        );
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => widget,
          ),
        );
      }
    },
    child: Text(
      text,
      style: linktTextStyle(fontSiza, darkTheme),
    ),
  );
}

CustomAuthButton backBtn(
  BuildContext context,
  bool darkTheme, {
  VoidCallback? action,
  double? width,
  double height = Variables.buttonHeightDefault,
}) {
  return CustomAuthButton(
    iconUrl: AImages.empty,
    style: defaultAuthButtonStyle(
      width: width ?? MediaQuery.of(context).size.width,
      height: height,
      darkTheme: darkTheme,
    ),
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

CustomAuthButton customButtonWithIcon(
  BuildContext context, {
  required String text,
  required ButtonStyleEnum buttonStyle,
  required bool darkTheme,
  bool autoWidth = false,
  double? width,
  double height = Variables.buttonHeightDefault,
  double? borderRadius,
  EdgeInsets? padding,
  String? iconUrl,
  VoidCallback? action,
}) {
  return CustomAuthButton(
    iconUrl: iconUrl ?? AImages.empty,
    style: buttonStyle == ButtonStyleEnum.primaryButton
        ? primaryButtonStyle(
            width:
                autoWidth ? null : width ?? MediaQuery.of(context).size.width,
            height: height,
            darkTheme: darkTheme,
            borderRadius: borderRadius,
            padding: padding,
            iconSize: Variables.buttonIconSizeSmall,
          )
        : buttonStyle == ButtonStyleEnum.secondaryButton
            ? secondaryButtonStyle(
                width: width ?? MediaQuery.of(context).size.width,
                height: height,
                darkTheme: darkTheme,
                borderRadius: borderRadius,
                padding: padding,
                iconSize: Variables.buttonIconSizeSmall,
              )
            : defaultAuthButtonStyle(
                width: width ?? MediaQuery.of(context).size.width,
                height: height,
                darkTheme: darkTheme,
                borderRadius: borderRadius,
                padding: padding,
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

Widget customButton({
  required bool darkTheme,
  required String text,
  required ButtonStyleEnum buttonStyle,
  double? width,
  double? height,
  double? borderRadius,
  EdgeInsets? padding,
  EdgeInsets? margin,
  VoidCallback? onPressed,
}) {
  BorderRadius? borderRad = borderRadius != null
      ? BorderRadius.horizontal(
          left: Radius.circular(
            borderRadius,
          ),
          right: Radius.circular(
            borderRadius,
          ),
        )
      : null;
  return Container(
    padding: margin,
    child: InkWell(
      onTap: () {
        if (onPressed != null) {
          onPressed();
        }
      },
      borderRadius: borderRad,
      child: Container(
        padding: padding,
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: buttonStyle == ButtonStyleEnum.primaryButton
              ? ThemeColor.of(darkTheme).buttonPrimary
              : buttonStyle == ButtonStyleEnum.secondaryButton
                  ? ThemeColor.of(darkTheme).buttonSecondary
                  : null,
          borderRadius: borderRad,
          border: Border.all(
            color: ThemeColor.of(darkTheme).buttonBorder,
            width: 1.0,
          ),
        ),
        child: Center(
          child: Text(
            text,
            style: simpleTextStyleColorable(
              Variables.fontSizeMedium,
              ThemeColor.of(darkTheme).buttonText,
            ),
          ),
        ),
      ),
    ),
  );
}

enum ButtonStyleEnum {
  defaultButton,
  primaryButton,
  secondaryButton,
}

Widget searchSuggestion(
  BuildContext context, {
  required String text,
  required bool darkTheme,
  VoidCallback? onPressed,
  VoidCallback? onLongPressed,
}) {
  return InkWell(
    onTap: onPressed,
    onLongPress: onLongPressed,
    child: Container(
      padding: EdgeInsets.symmetric(
          vertical: Variables.paddingDefault,
          horizontal: Variables.paddingNormal),
      width: MediaQuery.of(context).size.width,
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            text,
            style: simpleTextStyle(Variables.fontSizeMedium, darkTheme),
          ),
          const SizedBox(
            width: 5,
          ),
          Icon(
            Icons.history_outlined,
            color: ThemeColor.of(darkTheme).textPrimary,
          ),
        ],
      ),
    ),
  );
}

class ToolTipButton extends StatefulWidget {
  const ToolTipButton({
    Key? key,
    required this.darkTheme,
    required this.tooltip,
    this.text,
    this.icon,
    this.iconSize,
    this.width,
    this.height,
    this.color,
    this.activeColor,
    this.padding,
    this.decoration,
    this.onPressed,
  }) : super(key: key);
  final bool darkTheme;
  final String tooltip;
  final String? text;
  final IconData? icon;
  final double? iconSize;
  final double? width;
  final double? height;
  final Color? color;
  final Color? activeColor;
  final double? padding;
  final Decoration? decoration;
  final VoidCallback? onPressed;
  @override
  State<ToolTipButton> createState() => _ToolTipButtonState();
}

class _ToolTipButtonState extends State<ToolTipButton> {
  Color normalColor() {
    return widget.color ?? ThemeColor.of(widget.darkTheme).textPrimary;
  }

  Color hoverColor() {
    return ThemeColor.of(widget.darkTheme).textPrimaryHover;
  }

  Color? color;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: widget.tooltip,
      child: InkWell(
        onTap: widget.onPressed,
        onHover: (hovered) {
          if (hovered) {
            setState(() {
              color = hoverColor();
            });
          } else {
            setState(() {
              color = normalColor();
            });
          }
        },
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: widget.padding ?? 10,
          ),
          width: widget.width,
          height: widget.height,
          decoration: widget.decoration,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (widget.icon != null)
                Icon(
                  widget.icon,
                  color: widget.activeColor ?? color ?? normalColor(),
                  size: widget.iconSize ?? Variables.iconSizeMedium,
                ),
              if (widget.icon != null)
                const SizedBox(
                  width: 5,
                ),
              if (widget.text != null)
                Text(
                  widget.text!,
                  style: simpleTextStyleColorable(
                      Variables.fontSizeMedium, color ?? normalColor()),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget shareButton(
  BuildContext context, {
  required bool darkTheme,
  VoidCallback? onShared,
}) {
  return InkWell(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SharePage(
            darkTheme: darkTheme,
            onShared: onShared,
          ),
        ),
      );
    },
    child: Container(
      padding: const EdgeInsets.symmetric(
        vertical: 5.0,
        horizontal: 10.0,
      ),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        border: Border.all(
          color: ThemeColor.of(darkTheme).textPrimary,
          width: 1.5,
        ),
        borderRadius: BorderRadius.horizontal(
          left: Radius.circular(
            Variables.buttonRadiusRound,
          ),
          right: Radius.circular(Variables.buttonRadiusRound),
        ),
      ),
      child: Text(
        AppLocalizations.of(context).share_your_thoughts,
        style: simpleTextStyle(
          Variables.fontSizeMedium,
          darkTheme,
        ),
      ),
    ),
  );
}
