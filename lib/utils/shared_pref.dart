import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';
import '../models/user.dart';
import 'database/user_database.dart';

class SharedPref {
  static String userInfoString = "userInfo";
  static String darkTheme = "darkTheme";

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
}
