import 'package:flutter/material.dart';
import 'package:sosyal/utils/assets.dart';

Widget defaultProfileImage({double width = 100, double height = 100}) {
  return SizedBox(
    width: width,
    height: height,
    child: CircleAvatar(
      backgroundImage: AssetImage(
        AImages.profileImage,
      ),
    ),
  );
}

Widget profileImage(String path, {double width = 100, double height = 100}) {
  return SizedBox(
    width: width,
    height: height,
    child: CircleAvatar(
      backgroundImage: NetworkImage(path),
    ),
  );
}
