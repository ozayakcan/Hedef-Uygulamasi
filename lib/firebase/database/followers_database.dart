import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../models/key.dart';
import 'database.dart';

class FollowersDB {
  static DatabaseReference getFollowersRef(String userid) {
    return Database.getReference(Database.followString)
        .child(Database.followersString)
        .child(userid);
  }

  static DatabaseReference getFollowingRef(String userid) {
    return Database.getReference(Database.followString)
        .child(Database.followingString)
        .child(userid);
  }

  static Future<bool> checkFollowing(
      {required String follower, required String following}) async {
    DatabaseEvent databaseEvent =
        await getFollowersRef(following).child(follower).once();
    return databaseEvent.snapshot.exists;
  }

  static Future<int?> getFollowerCount(String userID) async {
    try {
      DatabaseReference databaseReference = getFollowersRef(userID);
      DatabaseEvent databaseEvent = await databaseReference.once();
      return databaseEvent.snapshot.children.length;
    } catch (e) {
      if (kDebugMode) {
        print("Takipçi sayısı alınamadı. Hata: " + e.toString());
      }
      return null;
    }
  }

  static Future<int?> getFollowCount(String userID) async {
    try {
      DatabaseReference databaseReference = getFollowingRef(userID);
      DatabaseEvent databaseEvent = await databaseReference.once();
      return databaseEvent.snapshot.children.length;
    } catch (e) {
      if (kDebugMode) {
        print("Takip edilen sayısı alınamadı. Hata: " + e.toString());
      }
      return null;
    }
  }

  static String convertFollowNumbers(BuildContext context, int number) {
    if (number > 999) {
      double convertedNumber = number / 1000;
      return AppLocalizations.of(context).thousand_convert.replaceAll(
            "%s",
            convertedNumber.toString(),
          );
    } else if (number > 999999) {
      double convertedNumber = number / 1000000;
      return AppLocalizations.of(context).million_convert.replaceAll(
            "%s",
            convertedNumber.toString(),
          );
    } else if (number > 999999999) {
      double convertedNumber = number / 1000000000;
      return AppLocalizations.of(context).billion_convert.replaceAll(
            "%s",
            convertedNumber.toString(),
          );
    } else {
      return number.toString();
    }
  }

  static Future follow(
      {required String follower, required String following}) async {
    try {
      await getFollowersRef(following)
          .child(follower)
          .set(KeyModel(follower).toJson());
      await getFollowingRef(follower)
          .child(following)
          .set(KeyModel(following).toJson());
      return null;
    } catch (e) {
      if (kDebugMode) {
        print("Takip Edilemedi! Hata: " + e.toString());
      }
      return e.toString();
    }
  }

  static Future unfollow(
      {required String follower, required String following}) async {
    try {
      getFollowersRef(following).child(follower).remove();
      getFollowingRef(follower).child(following).remove();
      return null;
    } catch (e) {
      if (kDebugMode) {
        print("Takipten Çıkılamadı! Hata: " + e.toString());
      }
      return e.toString();
    }
  }
}
