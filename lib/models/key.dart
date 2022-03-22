import '../utils/database/database.dart';

class KeyModel {
  final String key;
  KeyModel(
    this.key,
  );

  KeyModel.empty() : key = "";

  KeyModel.fromJson(Map<dynamic, dynamic> json)
      : key = json[Database.keyString] as String;

  Map<dynamic, dynamic> toJson() => <dynamic, dynamic>{
        Database.keyString: key,
      };
}
