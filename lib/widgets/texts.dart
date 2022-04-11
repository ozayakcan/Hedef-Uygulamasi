import 'package:flutter/material.dart';

import '../utils/colors.dart';

TextStyle titilliumWebTextStyle(Color color, double fontSize) {
  return TextStyle(
    color: color,
    fontSize: fontSize,
    fontFamily: "TitilliumWeb",
  );
}

TextStyle simpleTextStyle(double fontSize, bool darkTheme) {
  return TextStyle(
    color: darkTheme ? ThemeColorDark.textPrimary : ThemeColor.textPrimary,
    fontSize: fontSize,
  );
}

TextStyle simpleTextStyleSecondary(double fontSize, bool darkTheme) {
  return TextStyle(
    color: darkTheme ? ThemeColorDark.textSecondary : ThemeColor.textSecondary,
    fontSize: fontSize,
  );
}

TextStyle linktTextStyle(double fonstSize, bool darkTheme) {
  return TextStyle(
    color: darkTheme ? ThemeColorDark.buttonPrimary : ThemeColor.buttonPrimary,
    fontSize: fonstSize,
  );
}
