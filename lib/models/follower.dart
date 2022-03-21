import '../utils/database/database.dart';

class Follower {
  final String follower;
  final String followed;
  Follower(
    this.follower,
    this.followed,
  );

  Follower.empty()
      : follower = "",
        followed = "";

  Follower.fromJson(Map<dynamic, dynamic> json)
      : follower = json[Database.followerString] as String,
        followed = json[Database.followedString] as String;

  Map<dynamic, dynamic> toJson() => <dynamic, dynamic>{
        Database.followerString: follower,
        Database.followedString: followed,
      };
}
