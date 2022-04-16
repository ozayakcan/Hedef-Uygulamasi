import '../firebase/database/database.dart';
import '../utils/time.dart';

class ContentDateModel {
  final String key;
  final String content;
  final DateTime date;
  ContentDateModel(
    this.key,
    this.content,
    this.date,
  );

  ContentDateModel.empty()
      : key = "",
        content = "",
        date = Time.getTimeUtc();

  ContentDateModel.fromJson(Map<dynamic, dynamic> json)
      : key = json[Database.keyString] as String,
        content = json[Database.contentString] as String,
        date = Time.toLocal(timeString: json[Database.dateString] as String);

  Map<dynamic, dynamic> toJson() => <dynamic, dynamic>{
        Database.keyString: key,
        Database.contentString: content,
        Database.dateString: date.toString(),
      };
}
