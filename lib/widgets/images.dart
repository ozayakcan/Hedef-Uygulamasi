import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../utils/assets.dart';
import '../utils/colors.dart';

Widget profileImageButton(
  String path, {
  required bool darkTheme,
  required bool rounded,
  required VoidCallback? onPressed,
  double width = 100,
  double height = 100,
}) {
  return imageButton(
    darkTheme: darkTheme,
    rounded: rounded,
    onPressed: onPressed,
    child: profileImage(
      path,
      rounded: rounded,
      width: width,
      height: height,
    ),
  );
}

Widget profileImage(
  String path, {
  required bool rounded,
  double width = 100,
  double height = 100,
}) {
  return CachedNetworkImage(
    imageUrl: path,
    imageBuilder: (context, imageProvider) => profileImageWidget(
      imageProvider: imageProvider,
      width: width,
      height: height,
      rounded: rounded,
    ),
    placeholder: (context, url) => profileImageWidget(
      imageProvider: defaultProfileImageProvider,
      width: width,
      height: height,
      rounded: rounded,
    ),
    errorWidget: (context, url, error) => profileImageWidget(
      imageProvider: defaultProfileImageProvider,
      width: width,
      height: height,
      rounded: rounded,
    ),
    fadeInDuration: Duration.zero,
    fadeOutDuration: Duration.zero,
  );
}

ImageProvider defaultProfileImageProvider = AssetImage(AImages.profileImage);
double squareFullScreen(BuildContext context) {
  return MediaQuery.of(context).size.width > MediaQuery.of(context).size.height
      ? MediaQuery.of(context).size.height
      : MediaQuery.of(context).size.width;
}

Widget profileImageWidget({
  required ImageProvider imageProvider,
  required double width,
  required double height,
  required bool rounded,
}) {
  return Container(
    width: width,
    height: height,
    decoration: BoxDecoration(
      shape: rounded ? BoxShape.circle : BoxShape.rectangle,
      image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
    ),
  );
}

Widget cameraIcon({
  required bool darkTheme,
  required bool rounded,
  required VoidCallback? onPressed,
  double size = 20,
  double right = -30,
  double bottom = -5,
  double padding = 5,
}) {
  return Positioned(
    right: right,
    bottom: bottom,
    child: imageButton(
      darkTheme: darkTheme,
      rounded: rounded,
      child: Icon(
        Icons.camera_alt_outlined,
        size: size,
        color: darkTheme ? ThemeColorDark.textPrimary : ThemeColor.textPrimary,
      ),
      onPressed: onPressed,
    ),
  );
}

Widget imageButton({
  required bool darkTheme,
  required Widget child,
  required bool rounded,
  required VoidCallback? onPressed,
  double? padding,
}) {
  if (rounded) {
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
  } else {
    return RawMaterialButton(
      onPressed: onPressed,
      elevation: 2.0,
      fillColor: darkTheme
          ? ThemeColorDark.backgroundPrimary
          : ThemeColor.backgroundPrimary,
      child: child,
      padding: padding == null ? EdgeInsets.zero : EdgeInsets.all(padding),
    );
  }
}
