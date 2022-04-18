import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';

import '../../models/key.dart';
import 'database.dart';

class FavoritesDB {
  static DatabaseReference getFavoritesRef(String postKey) {
    return Database.getReference(Database.favoritesString).child(postKey);
  }

  static DatabaseReference favoritedRef(String postKey, String userid) {
    return Database.getReference(Database.favoritesString)
        .child(postKey)
        .child(userid);
  }

  static Future addFavorite(String postKey, String userid) async {
    try {
      DatabaseReference databaseReference = favoritedRef(postKey, userid);
      DatabaseEvent databaseEvent = await databaseReference.once();
      await favoritedRef(postKey, userid).set(
          databaseEvent.snapshot.exists ? null : KeyModel(userid).toJson());
      return null;
    } catch (e) {
      if (kDebugMode) {
        print("Favori eklenemedi. Hata: " + e.toString());
      }
      return e.toString();
    }
  }
}
