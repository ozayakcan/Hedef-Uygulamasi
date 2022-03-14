import 'package:shared_preferences/shared_preferences.dart';
import 'database.dart';

class SharedPref {
  static String userInfoString = "userInfo";

  static Future<List<String>> userInfo() async {
    final sp = await SharedPreferences.getInstance();
    return sp.getStringList(userInfoString) ?? List.empty();
  }

  static List<String> getUserInfoList(
      String id, String email, String username, String name) {
    return [
      id,
      email,
      username,
      name,
    ];
  }

  static Future registerUser() async {
    final sp = await SharedPreferences.getInstance();
    List<String> userInfoList =
        sp.getStringList(SharedPref.userInfoString) ?? List.empty();
    if (userInfoList.length >= 4) {
      final addUser = await Database.addUser(
          userInfoList[0], userInfoList[1], userInfoList[2], userInfoList[3]);
      if (addUser == null) {
        sp.remove(SharedPref.userInfoString);
      }
    }
  }
}
