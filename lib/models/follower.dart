import '../utils/database/database.dart';

class Follower {
  final String follower;
  Follower(
    this.follower,
  );

  Follower.empty() : follower = "";

  Follower.fromJson(Map<dynamic, dynamic> json)
      : follower = json[Database.followerString] as String;

  Map<dynamic, dynamic> toJson() => <dynamic, dynamic>{
        Database.followerString: follower,
      };
}
