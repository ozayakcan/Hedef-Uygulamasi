import 'package:flutter/material.dart';
import 'package:hedef/utils/colors.dart';

MaterialApp homeMaterialApp(Widget page) {
  return MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      scaffoldBackgroundColor: Colors.white,
      primarySwatch: MyColors.colorPrimary,
      visualDensity: VisualDensity.adaptivePlatformDensity,
    ),
    title: "Hedef",
    home: page,
  );
}
