import 'package:cached_network_image/cached_network_image.dart';
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
  return CachedNetworkImage(
    imageUrl: path,
    imageBuilder: (context, imageProvider) => Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
      ),
    ),
    placeholder: (context, url) => defaultProfileImage(
      width: width,
      height: height,
    ),
    errorWidget: (context, url, error) => defaultProfileImage(
      width: width,
      height: height,
    ),
    fadeInDuration: Duration.zero,
    fadeOutDuration: Duration.zero,
  );
}
