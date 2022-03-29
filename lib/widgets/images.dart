import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:sosyal/utils/assets.dart';
import 'package:sosyal/utils/colors.dart';

Widget defaultProfileImage({
  required bool darkTheme,
  required VoidCallback onPressed,
  double width = 100,
  double height = 100,
}) {
  return roundedImageButton(
    darkTheme: darkTheme,
    child: defaultProfileImageWidget(
      width: width,
      height: height,
    ),
    onPressed: onPressed,
  );
}

Widget defaultProfileImageWidget({
  required double width,
  required double height,
}) {
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

Widget profileImage(
  String path, {
  required bool darkTheme,
  required VoidCallback onPressed,
  double width = 100,
  double height = 100,
}) {
  return roundedImageButton(
    darkTheme: darkTheme,
    onPressed: onPressed,
    child: CachedNetworkImage(
      imageUrl: path,
      imageBuilder: (context, imageProvider) => Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
        ),
      ),
      placeholder: (context, url) => defaultProfileImageWidget(
        width: width,
        height: height,
      ),
      errorWidget: (context, url, error) => defaultProfileImageWidget(
        width: width,
        height: height,
      ),
      fadeInDuration: Duration.zero,
      fadeOutDuration: Duration.zero,
    ),
  );
}

Widget cameraIcon({
  required bool darkTheme,
  required VoidCallback onPressed,
  double size = 20,
  double right = -30,
  double bottom = -5,
  double padding = 5,
}) {
  return Positioned(
    right: right,
    bottom: bottom,
    child: roundedImageButton(
      darkTheme: darkTheme,
      child: Icon(Icons.camera_alt_outlined, size: size),
      onPressed: onPressed,
    ),
  );
}

Widget roundedImageButton({
  required bool darkTheme,
  required Widget child,
  required VoidCallback onPressed,
  double? padding,
}) {
  return RawMaterialButton(
    onPressed: onPressed,
    elevation: 2.0,
    fillColor: darkTheme
        ? ThemeColorDark.backgroundPrimary
        : ThemeColor.backgroundPrimary,
    child: child,
    padding: padding == null ? EdgeInsets.zero : EdgeInsets.all(padding),
    shape: const CircleBorder(),
  );
}
