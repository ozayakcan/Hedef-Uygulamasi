import '../firebase/database/database.dart';
import '../utils/time.dart';
import 'user.dart';

class PostModel {
  UserModel userModel = UserModel.empty();
  final String userid;
  final String key;
  final String content;
  final bool showContent;
  final String image;
  final DateTime date;
  PostModel(
    this.userModel,
    this.userid,
    this.key,
    this.content,
    this.showContent,
    this.image,
    this.date,
  );

  PostModel.empty()
      : key = "",
        userid = "",
        content = "",
        showContent = true,
        image = Database.emptyString,
        date = Time.getTimeUtc();

  PostModel.fromJson(Map<dynamic, dynamic> json)
      : key = json[Database.keyString] as String,
        userid = json[Database.useridString] as String,
        content = json[Database.contentString] as String,
        showContent = json[Database.showContentString] as bool,
        image = json[Database.imageString] as String,
        date = Time.toLocal(timeString: json[Database.dateString] as String);

  Map<dynamic, dynamic> toJson() => <dynamic, dynamic>{
        Database.keyString: key,
        Database.useridString: userid,
        Database.contentString: content,
        Database.showContentString: showContent,
        Database.imageString: image,
        Database.dateString: date.toString(),
      };
}
