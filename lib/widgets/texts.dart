import 'package:flutter/material.dart';

import '../utils/colors.dart';

TextStyle titilliumWebTextStyle(Color color, double _fontSize) {
  return TextStyle(
    color: color,
    fontSize: _fontSize,
    fontFamily: "TitilliumWeb",
  );
}

TextStyle simpleTextStyle(double _fontSize, bool darkTheme) {
  return TextStyle(
    color: darkTheme ? ThemeColorDark.textPrimary : ThemeColor.textPrimary,
    fontSize: _fontSize,
  );
}

TextStyle linktTextStyle(double _fonstSize, bool darkTheme) {
  return TextStyle(
    color: darkTheme ? ThemeColorDark.buttonPrimary : ThemeColor.buttonPrimary,
    fontSize: _fonstSize,
  );
}
