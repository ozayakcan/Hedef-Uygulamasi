import 'package:firebase_storage/firebase_storage.dart';

import '../database/database.dart';

typedef WhenComplete = void Function(String downloadUri);
typedef BeforeUpload = void Function();
typedef OnError = void Function();

class Storage {
  Storage(this.storage);

  static Storage of() {
    FirebaseStorage storage = FirebaseStorage.instance;
    return Storage(storage);
  }

  final FirebaseStorage storage;

  static String profileImageLocation(String userID) {
    return Database.usersString +
        "/" +
        userID +
        "/" +
        Database.profileImageString +
        "/";
  }

  static String postsLocation(String userID) {
    return Database.usersString +
        "/" +
        userID +
        "/" +
        Database.postsString +
        "/";
  }
}
