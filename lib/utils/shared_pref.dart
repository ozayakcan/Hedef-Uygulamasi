import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../firebase/database/user_database.dart';
import '../main.dart';
import '../models/user.dart';
import 'language.dart';

class SharedPref {
  static String userInfoString = "userInfo";
  static String darkTheme = "darkTheme";
  static String locale = "locale";

  static Future registerUser() async {
    final sp = await SharedPreferences.getInstance();
    List<String> userInfoList =
        sp.getStringList(SharedPref.userInfoString) ?? List.empty();
    if (userInfoList.length >= 4) {
      UserModel userModel = UserModel.fromList(userInfoList);
      final addUser = await UserDB.addUser(userModel);
      if (addUser == null) {
        sp.remove(SharedPref.userInfoString);
      }
    }
  }

  static Future<bool> setDarkTheme(bool status) async {
    final sp = await SharedPreferences.getInstance();
    sp.setBool(darkTheme, status);
    return status;
  }

  static void setDarkThemeRestart(BuildContext context, bool status) {
    SharedPref.setDarkTheme(status).then((value) {
      RestartAppWidget.restartApp(context);
    });
  }

  static Future<bool> isDarkTheme() async {
    final sp = await SharedPreferences.getInstance();
    return sp.getBool(darkTheme) ?? false;
  }

  static Future<String> setLocale(String _locale) async {
    final sp = await SharedPreferences.getInstance();
    sp.setString(locale, _locale);
    return _locale;
  }

  static void setLocaleRestart(BuildContext context, String _locale) async {
    SharedPref.setLocale(_locale).then((value) {
      RestartAppWidget.restartApp(context);
    });
  }

  static Future<String> getLocale() async {
    final sp = await SharedPreferences.getInstance();
    return sp.getString(locale) ?? getLanguageCode();
  }
}
