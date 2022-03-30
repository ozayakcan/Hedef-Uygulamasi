import 'package:firebase_storage/firebase_storage.dart';

typedef WhenComplete = void Function(String downloadUri);
typedef BeforeUpload = void Function();
typedef OnError = void Function();

class Storage {
  static final FirebaseStorage storage = FirebaseStorage.instance;
}
