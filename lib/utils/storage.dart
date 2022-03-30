import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_picker_web/image_picker_web.dart';

import 'database/database.dart';

typedef WhenComplete = void Function(String downloadUri);
typedef BeforeUpload = void Function();
typedef OnError = void Function();

class UploadProfileImage {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  final String userID;

  UploadProfileImage(
    this.userID, {
    this.whenComplete,
    this.beforeUpload,
    this.onError,
  });

  BeforeUpload? beforeUpload;
  WhenComplete? whenComplete;
  OnError? onError;

  Reference profileImageRef(String fileName) {
    return _storage
        .ref(Database.usersString +
            "/" +
            userID +
            "/" +
            Database.profileImageString)
        .child(fileName);
  }

  static SettableMetadata imageMetaData =
      SettableMetadata(contentType: "image/jpeg");

  Future fromGallery() async {
    try {
      if (kIsWeb) {
        return fromGalleryWeb();
      } else {
        return fromGalleryMobile();
      }
    } on FirebaseException catch (e) {
      onError?.call();
      return e.message;
    } catch (e) {
      onError?.call();
      return e.toString();
    }
  }

  Future fromGalleryMobile() async {
    final imagePicker = ImagePicker();
    final image = await imagePicker.pickImage(source: ImageSource.gallery);
    String fileName = DateTime.now().millisecondsSinceEpoch.toString() + ".jpg";
    beforeUpload?.call();
    if (image != null) {
      File imageFile = File(image.path);
      UploadTask task =
          profileImageRef(fileName).putFile(imageFile, imageMetaData);
      task.snapshotEvents.listen((event) async {
        if (event.state == TaskState.success) {
          String downloadUrl = await event.ref.getDownloadURL();
          whenComplete?.call(downloadUrl);
        }
      });
      await task;
      return null;
    } else {
      onError?.call();
      return "";
    }
  }

  Future fromGalleryWeb() async {
    Uint8List? imagePicker = await ImagePickerWeb.getImageAsBytes();
    String fileName = DateTime.now().millisecondsSinceEpoch.toString() + ".jpg";
    beforeUpload?.call();
    if (imagePicker != null) {
      UploadTask task =
          profileImageRef(fileName).putData(imagePicker, imageMetaData);
      task.snapshotEvents.listen((event) async {
        if (event.state == TaskState.success) {
          String downloadUrl = await event.ref.getDownloadURL();
          whenComplete?.call(downloadUrl);
        }
      });
      await task;
      return null;
    } else {
      onError?.call();
      return "";
    }
  }
}
