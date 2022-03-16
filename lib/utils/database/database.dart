import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';

class Database {
  static String usersString = "Users";
  static String idString = "id";
  static String emailString = "email";
  static String usernameString = "username";
  static String nameString = "name";

  static FirebaseDatabase getDatabase() {
    FirebaseDatabase database = FirebaseDatabase.instance;
    database.setLoggingEnabled(false);
    if (!kIsWeb) {
      database.setPersistenceEnabled(true);
      database.setPersistenceCacheSizeBytes(10000000);
    }
    return database;
  }

  static DatabaseReference getReference(String ref, {bool keepsynced = true}) {
    FirebaseDatabase database = getDatabase();
    DatabaseReference reference = database.ref(ref);
    setKeepSynced(reference, keepsynced);
    return reference;
  }

  static void setKeepSynced(DatabaseReference databaseReference, bool status) {
    if (!kIsWeb) {
      databaseReference.keepSynced(status);
    }
  }

  static void printError(Object e) {
    if (kDebugMode) {
      print("Veritabanı Hatası: " + e.toString());
    }
  }
}
