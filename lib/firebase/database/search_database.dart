import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';

import '../../models/content_date.dart';
import '../../models/user.dart';
import '../../utils/time.dart';
import 'database.dart';
import 'user_database.dart';

class SearchDB {
  static DatabaseReference getLogsRef(String userid) {
    return Database.getReference(Database.searchLogString + "/" + userid);
  }

  static Future addLog(
      {required String userid, required String searchStr}) async {
    try {
      List<ContentDateModel> logs = await getLogs(
        userid,
        query: searchStr,
      );
      if (logs.isEmpty) {
        String key = getLogsRef(userid).push().key!;
        DatabaseReference databaseReference = getLogsRef(userid).child(key);
        await databaseReference.set(
            ContentDateModel(key, searchStr.toLowerCase(), Time.getTimeUtc())
                .toJson());
      }
      return null;
    } catch (e) {
      if (kDebugMode) {
        print("Arama kaydı eklenemedi! Hata: " + e.toString());
      }
      return e.toString();
    }
  }

  static Future removeLog({required String userid, required String key}) async {
    try {
      await getLogsRef(userid).child(key).set(null);
      return null;
    } catch (e) {
      if (kDebugMode) {
        print("Arama kaydı silinemedi! Hata: " + e.toString());
      }
      return e.toString();
    }
  }

  static Future<List<ContentDateModel>> getLogs(String userid,
      {String query = ""}) async {
    List<ContentDateModel> queries = [];
    try {
      DatabaseEvent databaseEvent;
      if (query == "") {
        databaseEvent = await getLogsRef(userid)
            .orderByChild(Database.dateString)
            .limitToLast(3)
            .once();
      } else {
        databaseEvent = await getLogsRef(userid)
            .orderByChild(Database.contentString)
            .equalTo(query.toLowerCase())
            .limitToFirst(1)
            .once();
      }
      for (final child in databaseEvent.snapshot.children) {
        final json = child.value as Map<dynamic, dynamic>;
        ContentDateModel searchLogModel = ContentDateModel.fromJson(json);
        queries.add(searchLogModel);
      }
      return queries;
    } catch (e) {
      if (kDebugMode) {
        print("Arama kaydı getirilemedi! Hata: " + e.toString());
      }
      return queries;
    }
  }

  static Future<List<UserModel>> searchUsers(String query) async {
    List<UserModel> users = [];
    try {
      DatabaseEvent usersEvent = await UserDB.getAllUsersRef().once();
      for (final child in usersEvent.snapshot.children) {
        final json = child.value as Map<dynamic, dynamic>;
        UserModel userModel = UserModel.fromJson(json);
        String usernameLower = userModel.getUserNameAt.toLowerCase();
        String usernameUpper = userModel.getUserNameAt.toUpperCase();
        String nameLower = userModel.name.toLowerCase();
        String nameUpper = userModel.name.toUpperCase();
        String queryLower = query.toLowerCase();
        String queryUpper = query.toUpperCase();
        if (usernameLower.contains(queryLower) ||
            usernameUpper.contains(queryUpper) ||
            nameLower.contains(queryLower) ||
            nameUpper.contains(queryUpper)) {
          users.add(userModel);
        }
      }
      return users;
    } catch (e) {
      if (kDebugMode) {
        print("Arama gerçekleşemedi! Hata: " + e.toString());
      }
      return users;
    }
  }
}
