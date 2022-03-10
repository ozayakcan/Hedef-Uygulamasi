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
    color: Colors.black87,
    fontSize: _fontSize,
  );
}

TextStyle simpleTextStyleWhite(double _fontSize) {
  return TextStyle(
    color: Colors.white,
    fontSize: _fontSize,
  );
}

TextStyle linktTextStyle(double _fonstSize) {
  return TextStyle(
    color: MyColors.colorPrimary,
    fontSize: _fonstSize,
  );
}
