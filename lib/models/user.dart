class UserModel {
  final String id;
  final String email;
  final String username;
  final String name;
  final DateTime registeredDate;
  UserModel(this.id, this.email, this.username, this.name, this.registeredDate);

  UserModel.fromJson(Map<dynamic, dynamic> json)
      : id = json['id'] as String,
        email = json['email'] as String,
        username = json['username'] as String,
        name = json['name'] as String,
        registeredDate = DateTime.parse(json['registeredDate'] as String);

  Map<dynamic, dynamic> toJson() => <dynamic, dynamic>{
        'id': id,
        'email': email,
        'username': username,
        'name': name,
        'registeredDate': registeredDate.toString(),
      };

  UserModel.fromList(List<String> list)
      : id = list[0],
        email = list[1],
        username = list[2],
        name = list[3],
        registeredDate = DateTime.parse(list[4]);
  List<String> toList() => [
        id,
        email,
        username,
        name,
        registeredDate.toString(),
      ];
}
