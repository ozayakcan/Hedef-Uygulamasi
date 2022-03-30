import 'package:permission_handler/permission_handler.dart';

class RequestPermissions {
  static Future<PermissionStatus> photoPermission() async {
    await Permission.photos.request();
    return Permission.photos.status;
  }
}
