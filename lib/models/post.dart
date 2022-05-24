import '../firebase/database/database.dart';
import '../utils/time.dart';
import 'user.dart';

class PostModel {
  UserModel userModel = UserModel.empty();
  final String userid;
  final String key;
  final String content;
  final String image;
  final DateTime date;
  PostModel(
    this.userModel,
    this.userid,
    this.key,
    this.content,
    this.image,
    this.date,
  );

  PostModel.empty()
      : key = "",
        userid = "",
        content = "",
        image = Database.emptyString,
        date = Time.getTimeUtc();

  PostModel.fromJson(Map<dynamic, dynamic> json)
      : key = json[Database.keyString] as String,
        userid = json[Database.useridString] as String,
        content = json[Database.contentString] as String,
        image = json[Database.imageString] as String,
        date = Time.toLocal(timeString: json[Database.dateString] as String);

  Map<dynamic, dynamic> toJson() => <dynamic, dynamic>{
        Database.keyString: key,
        Database.useridString: userid,
        Database.contentString: content,
        Database.imageString: image,
        Database.dateString: date.toString(),
      };
  static List<PostModel> sort(List<PostModel> posts, {bool descending = true}) {
    if (descending) {
      posts.sort((a, b) => b.date.compareTo(a.date));
    } else {
      posts.sort((a, b) => a.date.compareTo(b.date));
    }
    return posts;
  }
}
