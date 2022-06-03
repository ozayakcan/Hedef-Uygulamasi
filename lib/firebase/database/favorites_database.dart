import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';

import '../../models/key.dart';
import 'database.dart';

class FavoritesDB {
  static DatabaseReference getFavoritesOfPostRef(String postKey) {
    return Database.getReference(Database.favoritesString)
        .child(Database.postsString)
        .child(postKey);
  }

  static DatabaseReference favoritedPostRef(String postKey, String userid) {
    return Database.getReference(Database.favoritesString)
        .child(Database.postsString)
        .child(postKey)
        .child(userid);
  }

  static DatabaseReference getFavoritesOfUserRef(String userid) {
    return Database.getReference(Database.favoritesString)
        .child(Database.usersString)
        .child(userid);
  }

  static DatabaseReference userFavoritesRef(String userid) {
    return Database.getReference(Database.favoritesString)
        .child(Database.usersString)
        .child(userid);
  }

  static DatabaseReference favoritedUserRef(String postKey, String userid) {
    return userFavoritesRef(userid).child(postKey);
  }

  static Future addFavorite(String postKey, String userid) async {
    try {
      DatabaseReference databaseReference = favoritedPostRef(postKey, userid);
      DatabaseEvent databaseEvent = await databaseReference.once();
      await favoritedPostRef(postKey, userid).set(
          databaseEvent.snapshot.exists ? null : KeyModel(userid).toJson());
      await favoritedUserRef(postKey, userid).set(
          databaseEvent.snapshot.exists ? null : KeyModel(postKey).toJson());
      return null;
    } catch (e) {
      if (kDebugMode) {
        print("Favori eklenemedi. Hata: " + e.toString());
      }
      return e.toString();
    }
  }

  static Future<List<String>> getUserFavorites(
      DatabaseEvent databaseEvent) async {
    List<String> userFavorites = [];
    try {
      for (final databaseEventChild in databaseEvent.snapshot.children) {
        final jsonUserFavorites =
            databaseEventChild.value as Map<dynamic, dynamic>;
        userFavorites.add(KeyModel.fromJson(jsonUserFavorites).key);
      }
      return userFavorites;
    } catch (e) {
      if (kDebugMode) {
        print("Favori eklenemedi. Hata: " + e.toString());
      }
      return userFavorites;
    }
  }
}
