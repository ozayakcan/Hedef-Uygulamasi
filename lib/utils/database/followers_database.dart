import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:sosyal/models/follower.dart';

import 'database.dart';

class FollowersDB {
  static DatabaseReference getFollowersRef(String userid) {
    return Database.getReference(Database.followersString + "/" + userid);
  }

  static Query getSingleFollowerQuery({
    required String follower,
    required String followed,
  }) {
    return Database.getReference(Database.followersString + "/" + followed)
        .orderByChild(Database.followerString)
        .equalTo(follower)
        .limitToFirst(1);
  }

  static Future<bool> checkFollowing(
      {required String follower, required String followed}) async {
    DatabaseEvent databaseEvent =
        await getSingleFollowerQuery(follower: follower, followed: followed)
            .once();
    return databaseEvent.snapshot.exists;
  }

  static Future follow(
      {required String follower, required String followed}) async {
    try {
      await getFollowersRef(followed).push().set(Follower(follower).toJson());
      return null;
    } catch (e) {
      if (kDebugMode) {
        print("Follow Hata: " + e.toString());
      }
      return e.toString();
    }
  }

  static Future unfollow(
      {required String follower, required String followed}) async {
    try {
      getSingleFollowerQuery(follower: follower, followed: followed)
          .once()
          .then((value) async {
        if (value.snapshot.exists) {
          await value.snapshot.children.first.ref.remove();
        }
      });
      return null;
    } catch (e) {
      if (kDebugMode) {
        print("Unfollow Hata: " + e.toString());
      }
      return e.toString();
    }
  }
}
