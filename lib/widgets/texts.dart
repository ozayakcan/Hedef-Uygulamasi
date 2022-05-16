import 'package:flutter/material.dart';

import '../utils/theme_colors.dart';
import '../utils/variables.dart';

TextStyle titilliumWebTextStyle(Color color, double fontSize) {
  return TextStyle(
    color: color,
    fontSize: fontSize,
    fontFamily: "TitilliumWeb",
  );
}

TextStyle simpleTextStyle(double fontSize, bool darkTheme) {
  return TextStyle(
    color: ThemeColor.of(darkTheme).textPrimary,
    fontSize: fontSize,
  );
}

TextStyle simpleTextStyleSecondary(double fontSize, bool darkTheme) {
  return TextStyle(
    color: ThemeColor.of(darkTheme).textSecondary,
    fontSize: fontSize,
  );
}

TextStyle simpleTextStyleBold(bool darkTheme) {
  return TextStyle(
    fontWeight: FontWeight.bold,
    color: ThemeColor.of(darkTheme).textSecondary,
  );
}

TextStyle simpleTextStyleColorable(double fontSize, Color color) {
  return TextStyle(
    color: color,
    fontSize: fontSize,
  );
}

TextStyle linktTextStyle(double fonstSize, bool darkTheme) {
  return TextStyle(
    color: ThemeColor.of(darkTheme).link,
    fontSize: fonstSize,
  );
}

Widget highlightTextWidget(
  String text,
  String query, {
  required bool darkTheme,
  TextStyle? style,
}) {
  style ??= simpleTextStyle(Variables.fontSizeMedium, darkTheme);

  final List<TextSpan> textSpanList = [];
  if (query.isEmpty || !text.toLowerCase().contains(query.toLowerCase())) {
    textSpanList.add(TextSpan(text: text));
    return RichText(
      text: TextSpan(
        children: textSpanList,
        style: style,
      ),
    );
  }
  final matches = query.toLowerCase().allMatches(text.toLowerCase());

  int lastMatchEnd = 0;
  for (var i = 0; i < matches.length; i++) {
    final match = matches.elementAt(i);

    if (match.start != lastMatchEnd) {
      textSpanList.add(
        TextSpan(
          text: text.substring(lastMatchEnd, match.start),
        ),
      );
    }

    textSpanList.add(
      TextSpan(
        text: text.substring(match.start, match.end),
        style: simpleTextStyleBold(darkTheme),
      ),
    );

    if (i == matches.length - 1 && match.end != text.length) {
      textSpanList.add(
        TextSpan(
          text: text.substring(match.end, text.length),
        ),
      );
    }

    lastMatchEnd = match.end;
  }
  return RichText(
    text: TextSpan(
      children: textSpanList,
      style: style,
    ),
  );
}
