import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sosyal/utils/shared_pref.dart';

import 'auth.dart';

class Database {
  static String usersString = "Users";
  static String idString = "id";
  static String emailString = "email";
  static String usernameString = "username";
  static String nameString = "name";

  static Future<FirebaseDatabase> getDatabase() async {
    FirebaseDatabase database = FirebaseDatabase.instance;
    database.setLoggingEnabled(false);
    if (!kIsWeb) {
      database.setPersistenceEnabled(true);
      database.setPersistenceCacheSizeBytes(10000000);
    }
    return database;
  }

  static Future<bool?> checkUsername(String username) async {
    try {
      FirebaseDatabase database = await getDatabase().then((value) => value);
      DatabaseReference databaseReference = database.ref(usersString);
      setKeepSynced(databaseReference, true);
      return databaseReference
          .orderByChild(usernameString)
          .equalTo(username)
          .limitToFirst(1)
          .once()
          .then((value) {
        return value.snapshot.exists;
      });
    } catch (e) {
      printError(e);
      return null;
    }
  }

  static Future<bool?> checkUserRegistered(String userid) async {
    try {
      FirebaseDatabase database = await getDatabase().then((value) => value);
      DatabaseReference databaseReference = database.ref(usersString);
      setKeepSynced(databaseReference, true);
      return databaseReference
          .orderByChild(idString)
          .equalTo(userid)
          .limitToFirst(1)
          .once()
          .then((value) {
        return value.snapshot.exists;
      });
    } catch (e) {
      printError(e);
      return null;
    }
  }

  static void addGoogleUser() {
    User? user = Auth.user;
    if (user != null) {
      Database.checkUserRegistered(user.uid).then((value) {
        if (value != null) {
          if (value == false) {
            Database.addUser(user.uid, user.email!, user.uid, user.displayName!)
                .then((value) {});
          }
        }
      });
    }
  }

  static Future addUser(
      String id, String email, String username, String name) async {
    try {
      FirebaseDatabase database = await getDatabase().then((value) => value);
      DatabaseReference databaseReference = database.ref(usersString).child(id);
      setKeepSynced(databaseReference, true);
      await databaseReference.set({
        idString: id,
        emailString: email,
        usernameString: username,
        nameString: name,
      });
      return null;
    } catch (e) {
      final sp = await SharedPreferences.getInstance();
      sp.setStringList(
        SharedPref.userInfoString,
        SharedPref.getUserInfoList(
          id,
          email,
          username,
          name,
        ),
      );
      printError(e);
      return e.toString();
    }
  }

  static void setKeepSynced(DatabaseReference databaseReference, bool status) {
    if (!kIsWeb) {
      databaseReference.keepSynced(status);
    }
  }

  static void printError(Object e) {
    if (kDebugMode) {
      print("Veritabanı Hatası: " + e.toString());
    }
  }
}
