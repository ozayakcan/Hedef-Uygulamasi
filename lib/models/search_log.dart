import '../firebase/database/database.dart';
import '../utils/time.dart';

class SearchLogModel {
  final String key;
  final String query;
  final DateTime date;
  SearchLogModel(
    this.key,
    this.query,
    this.date,
  );

  SearchLogModel.empty()
      : key = "",
        query = "",
        date = Time.getTimeUtc();

  SearchLogModel.fromJson(Map<dynamic, dynamic> json)
      : key = json[Database.keyString] as String,
        query = json[Database.queryString] as String,
        date = Time.toLocal(timeString: json[Database.dateString] as String);

  Map<dynamic, dynamic> toJson() => <dynamic, dynamic>{
        Database.keyString: key,
        Database.queryString: query,
        Database.dateString: date.toString(),
      };
}
