import 'package:firebase_storage/firebase_storage.dart';

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
}
