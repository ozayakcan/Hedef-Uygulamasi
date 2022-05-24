import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../utils/permissions.dart';
import '../../utils/time.dart';
import '../../widgets/widgets.dart';
import 'storage.dart';

class UploadImage {
  UploadImage(
    this.context, {
    required this.uploadLocation,
    this.whenComplete,
    this.beforeUpload,
    this.onError,
  });

  static Future<UploadImage> fromGallery(
    BuildContext context, {
    required String uploadLocation,
    WhenComplete? whenComplete,
    BeforeUpload? beforeUpload,
    OnError? onError,
  }) async {
    UploadImage uploadProfileImage = UploadImage(
      context,
      uploadLocation: uploadLocation,
      whenComplete: whenComplete,
      beforeUpload: beforeUpload,
      onError: onError,
    );
    await uploadProfileImage._fromGallery();
    return uploadProfileImage;
  }

  final BuildContext context;
  final String uploadLocation;
  BeforeUpload? beforeUpload;
  WhenComplete? whenComplete;
  OnError? onError;

  Reference imageRef(String fileName) {
    return Storage.of().storage.ref(uploadLocation + fileName);
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
          Time.getTimeUtc().millisecondsSinceEpoch.toString() + ".jpg";
      beforeUpload?.call();
      if (image != null) {
        UploadTask task;
        if (kIsWeb) {
          Uint8List imageFile = await image.readAsBytes();
          task = imageRef(fileName).putData(imageFile, imageMetaData);
        } else {
          File imageFile = File(image.path);
          task = imageRef(fileName).putFile(imageFile, imageMetaData);
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
