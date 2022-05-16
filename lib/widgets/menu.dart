import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../firebase/auth.dart';
import '../utils/theme_colors.dart';
import '../utils/shared_pref.dart';
import '../utils/variables.dart';
import '../views/login.dart';
import '../views/settings.dart';
import 'texts.dart';

Widget mainPopupMenu(BuildContext context,
    {required bool darkTheme, bool showSettings = true}) {
  return PopupMenuButton(
    icon: Icon(
      Icons.more_vert,
      color: ThemeColor.of(darkTheme).textPrimary,
    ),
    color: ThemeColor.of(darkTheme).backgroundPrimary,
    elevation: 20,
    shape: OutlineInputBorder(
      borderSide: BorderSide(
        color: ThemeColor.of(darkTheme).textSecondary,
        width: 2,
      ),
    ),
    onSelected: (value) {
      if (value == AppLocalizations.of(context).dark_theme) {
        SharedPref.setDarkThemeRestart(context, !darkTheme);
      } else if (value == AppLocalizations.of(context).settings) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Settings(
              darkTheme: darkTheme,
            ),
          ),
        );
      } else if (value == AppLocalizations.of(context).logout) {
        Auth.auth.signOut();
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => Login(
              darkTheme: darkTheme,
            ),
          ),
          (route) => false,
        );
      }
    },
    itemBuilder: (context) => [
      PopupMenuItem(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              AppLocalizations.of(context).dark_theme,
              style: simpleTextStyle(Variables.fontSizeNormal, darkTheme),
            ),
            const SizedBox(
              width: 30,
            ),
            Text(
              darkTheme
                  ? AppLocalizations.of(context).on
                  : AppLocalizations.of(context).off,
              style:
                  simpleTextStyleSecondary(Variables.fontSizeNormal, darkTheme),
            )
          ],
        ),
        value: AppLocalizations.of(context).dark_theme,
      ),
      if (showSettings)
        PopupMenuItem(
          child: Text(
            AppLocalizations.of(context).settings,
            style: simpleTextStyle(Variables.fontSizeNormal, darkTheme),
          ),
          value: AppLocalizations.of(context).settings,
        ),
      PopupMenuItem(
        child: Text(
          AppLocalizations.of(context).logout,
          style: simpleTextStyle(Variables.fontSizeNormal, darkTheme),
        ),
        value: AppLocalizations.of(context).logout,
      ),
    ],
  );
}
