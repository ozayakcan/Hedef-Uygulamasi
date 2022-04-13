import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/user.dart';
import '../../utils/shared_pref.dart';
import '../auth.dart';
import 'database.dart';

class UserDB {
  static Future<bool?> checkUsername(String username) async {
    try {
      DatabaseReference databaseReference =
          Database.getReference(Database.usersString);
      return databaseReference
          .orderByChild(Database.usernameString)
          .equalTo(username)
          .limitToFirst(1)
          .once()
          .then((value) {
        return value.snapshot.exists;
      });
    } catch (e) {
      Database.printError(e);
      return null;
    }
  }

  static Future<bool?> checkUserRegistered(String userid) async {
    try {
      DatabaseReference databaseReference =
          Database.getReference(Database.usersString);
      return databaseReference
          .orderByChild(Database.idString)
          .equalTo(userid)
          .limitToFirst(1)
          .once()
          .then((value) {
        return value.snapshot.exists;
      });
    } catch (e) {
      Database.printError(e);
      return null;
    }
  }

  static void addGoogleUser() {
    User? user = Auth.user;
    if (user != null) {
      checkUserRegistered(user.uid).then((value) {
        if (value != null) {
          if (value == false) {
            UserModel userModel = UserModel(user.uid, user.email!, user.uid,
                user.displayName!, DateTime.now(), Database.defaultValue);
            addUser(userModel).then((value) {});
          }
        }
      });
    }
  }

  static Future addUser(UserModel userModel) async {
    try {
      await getUserRef(userModel.id).set(userModel.toJson());
      return null;
    } catch (e) {
      final sp = await SharedPreferences.getInstance();
      sp.setStringList(
        SharedPref.userInfoString,
        userModel.toList(),
      );
      Database.printError(e);
      return e.toString();
    }
  }

  static DatabaseReference getUserRef(String userid) {
    return Database.getReference(Database.usersString + "/" + userid);
  }

  static Query getUserQueryByUsername(String username) {
    return Database.getReference(Database.usersString)
        .orderByChild(Database.usernameString)
        .equalTo(username)
        .limitToFirst(1);
  }

  static Query getUserQueryByID(String userid) {
    return Database.getReference(Database.usersString).child(userid);
  }

  static Future<List<UserModel>> getUsersFromID(List<String> ids) async {
    List<UserModel> list = [];
    try {
      for (final id in ids) {
        DatabaseEvent databaseEvent = await UserDB.getUserQueryByID(id).once();
        if (databaseEvent.snapshot.exists) {
          final json = databaseEvent.snapshot.value as Map<dynamic, dynamic>;
          list.add(UserModel.fromJson(json));
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print("Kullanıcılar getirilemedi! Hata: " + e.toString());
      }
    }
    return list;
  }

  static Future updateProfileImage(String userID, String imageUrl) async {
    try {
      DatabaseReference reference =
          getUserRef(userID).child(Database.profileImageString);
      await reference.set(imageUrl);
      return null;
    } on FirebaseException catch (e) {
      return e.message;
    } catch (e) {
      return e.toString();
    }
  }

  static DatabaseReference getAllUsersRef() {
    return Database.getReference(Database.usersString);
  }
}
