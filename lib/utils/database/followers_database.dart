import 'package:firebase_database/firebase_database.dart';

import 'database.dart';

class FollowersDB {
  static Query getFollowQuery(
    String userid, {
    required bool isFollower,
    bool singleValue = false,
    String seconUserId = "",
  }) {
    Query followQuery = Database.getReference(Database.followersString);
    if (isFollower) {
      followQuery =
          followQuery.orderByChild(Database.followerString).equalTo(userid);
    } else {
      followQuery =
          followQuery.orderByChild(Database.followedString).equalTo(userid);
    }
    if (singleValue && seconUserId != "") {
      if (isFollower) {
        followQuery = followQuery
            .orderByChild(Database.followedString)
            .equalTo(seconUserId)
            .limitToFirst(1);
      } else {
        followQuery = followQuery
            .orderByChild(Database.followerString)
            .equalTo(seconUserId)
            .limitToFirst(1);
      }
    }
    return followQuery;
  }
}
