import '../utils/database/database.dart';

class UserModel {
  final String id;
  final String email;
  final String username;
  final String name;
  final DateTime registeredDate;
  final String profileImage;
  UserModel(
    this.id,
    this.email,
    this.username,
    this.name,
    this.registeredDate,
    this.profileImage,
  );

  UserModel.empty()
      : id = "",
        email = "",
        username = "",
        name = "",
        registeredDate = DateTime.now(),
        profileImage = Database.defaultValue;

  UserModel.fromJson(Map<dynamic, dynamic> json)
      : id = json[Database.idString] as String,
        email = json[Database.emailString] as String,
        username = json[Database.usernameString] as String,
        name = json[Database.nameString] as String,
        registeredDate =
            DateTime.parse(json[Database.registeredDateString] as String),
        profileImage = json[Database.profileImageString] as String;

  Map<dynamic, dynamic> toJson() => <dynamic, dynamic>{
        Database.idString: id,
        Database.emailString: email,
        Database.usernameString: username,
        Database.nameString: name,
        Database.registeredDateString: registeredDate.toString(),
        Database.profileImageString: profileImage,
      };

  UserModel.fromList(List<String> list)
      : id = list[0],
        email = list[1],
        username = list[2],
        name = list[3],
        registeredDate = DateTime.parse(list[4]),
        profileImage = list[5];
  List<String> toList() => [
        id,
        email,
        username,
        name,
        registeredDate.toString(),
        profileImage,
      ];

  String get getUserName => "(@" + username + ")";
}
