import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../widgets/widgets.dart';
import 'database/database.dart';
import 'permissions.dart';

typedef WhenComplete = void Function(String downloadUri);
typedef BeforeUpload = void Function();
typedef OnError = void Function();

class UploadProfileImage {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  UploadProfileImage(
    this.context, {
    required this.userID,
    this.whenComplete,
    this.beforeUpload,
    this.onError,
  });

  static Future<UploadProfileImage> fromGallery(
    BuildContext context, {
    required String userID,
    WhenComplete? whenComplete,
    BeforeUpload? beforeUpload,
    OnError? onError,
  }) async {
    UploadProfileImage uploadProfileImage = UploadProfileImage(context,
        userID: userID,
        whenComplete: whenComplete,
        beforeUpload: beforeUpload,
        onError: onError);
    await uploadProfileImage._fromGallery();
    return uploadProfileImage;
  }

  final BuildContext context;
  final String userID;
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

  Future _fromGallery() async {
    try {
      if (!kIsWeb) {
        var permissionStatus = RequestPermissions.photoPermission();
        if (await permissionStatus.isGranted == false) {
          ScaffoldSnackbar.of(context)
              .show(AppLocalizations.of(context).permissions_not_granted);
          return "";
        }
      }
      final imagePicker = ImagePicker();
      XFile? image = await imagePicker.pickImage(source: ImageSource.gallery);
      String fileName =
          DateTime.now().millisecondsSinceEpoch.toString() + ".jpg";
      beforeUpload?.call();
      if (image != null) {
        UploadTask task;
        if (kIsWeb) {
          Uint8List imageFile = await image.readAsBytes();
          task = profileImageRef(fileName).putData(imageFile, imageMetaData);
        } else {
          File imageFile = File(image.path);
          task = profileImageRef(fileName).putFile(imageFile, imageMetaData);
        }
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
    } on FirebaseException catch (e) {
      onError?.call();
      return e.message;
    } catch (e) {
      onError?.call();
      return e.toString();
    }
  }
}
