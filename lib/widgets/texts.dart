import 'package:flutter/material.dart';

import '../utils/colors.dart';

TextStyle titilliumWebTextStyle(Color color, double _fontSize) {
  return TextStyle(
    color: color,
    fontSize: _fontSize,
    fontFamily: "TitilliumWeb",
  );
}

TextStyle simpleTextStyle(double _fontSize) {
  return TextStyle(
    color: ThemeColor.textPrimary,
    fontSize: _fontSize,
  );
}

TextStyle linktTextStyle(double _fonstSize) {
  return TextStyle(
    color: ThemeColor.buttonPrimary,
    fontSize: _fonstSize,
  );
}
