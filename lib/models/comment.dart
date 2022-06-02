import '../firebase/database/database.dart';
import '../utils/time.dart';
import 'user.dart';

class CommentModel {
  UserModel userModel = UserModel.empty();
  final String key;
  final String userid;
  final String comment;
  final DateTime date;
  CommentModel(
    this.userModel,
    this.key,
    this.userid,
    this.comment,
    this.date,
  );

  CommentModel.empty()
      : key = "",
        userid = "",
        comment = "",
        date = Time.getTimeUtc();

  CommentModel.fromJson(Map<dynamic, dynamic> json)
      : key = json[Database.keyString] as String,
        userid = json[Database.useridString] as String,
        comment = json[Database.commentString] as String,
        date = Time.toLocal(timeString: json[Database.dateString] as String);

  Map<dynamic, dynamic> toJson() => <dynamic, dynamic>{
        Database.keyString: key,
        Database.useridString: userid,
        Database.commentString: comment,
        Database.dateString: date.toString(),
      };
}
