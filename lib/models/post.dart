import '../firebase/database/database.dart';
import 'user.dart';

class Post {
  UserModel userModel = UserModel.empty();
  final String key;
  final String content;
  final DateTime date;
  Post(
    this.userModel,
    this.key,
    this.content,
    this.date,
  );

  Post.empty()
      : key = "",
        content = "",
        date = DateTime.now();

  Post.fromJson(Map<dynamic, dynamic> json)
      : key = json[Database.keyString] as String,
        content = json[Database.contentString] as String,
        date = DateTime.parse(json[Database.dateString] as String);

  Map<dynamic, dynamic> toJson() => <dynamic, dynamic>{
        Database.keyString: key,
        Database.contentString: content,
        Database.dateString: date.toString(),
      };
  static List<Post> sort(List<Post> posts, {bool descending = true}) {
    if (descending) {
      posts.sort((a, b) => b.date.compareTo(a.date));
    } else {
      posts.sort((a, b) => a.date.compareTo(b.date));
    }
    return posts;
  }
}
