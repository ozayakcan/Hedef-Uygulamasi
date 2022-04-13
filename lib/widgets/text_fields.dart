import 'package:auth_buttons/auth_buttons.dart';
import 'package:flutter/material.dart';

import '../utils/colors.dart';
import '../utils/variables.dart';

TextField customTextField(BuildContext context, bool darkTheme,
    {required String labelText,
    required TextEditingController textController,
    TextInputType? inputType,
    int? maxLength,
    CustomAuthButton? authButton,
    FocusNode? prevFocus,
    FocusNode? nextFocus}) {
  return TextField(
    controller: textController,
    focusNode: prevFocus,
    keyboardType: inputType ?? TextInputType.name,
    maxLength: maxLength,
    textInputAction:
        nextFocus != null ? TextInputAction.next : TextInputAction.done,
    style: TextStyle(
      color: darkTheme ? ThemeColorDark.textPrimary : ThemeColor.textPrimary,
    ),
    decoration: InputDecoration(
      labelText: labelText,
      labelStyle: TextStyle(
        color: darkTheme ? ThemeColorDark.textPrimary : ThemeColor.textPrimary,
      ),
      enabledBorder: enabledInputBorder(darkTheme),
      focusedBorder: focusedInputBorder(darkTheme),
    ),
    onSubmitted: (v) {
      if (authButton != null) {
        authButton.onPressed!();
        return;
      }
      if (nextFocus != null) {
        FocusScope.of(context).requestFocus(nextFocus);
        return;
      }
    },
  );
}

TextField passwordTextField(BuildContext context, bool darkTheme,
    {required String pwtext,
    required TextEditingController passwordController,
    CustomAuthButton? authButton,
    FocusNode? prevFocus,
    FocusNode? nextFocus}) {
  return TextField(
    controller: passwordController,
    focusNode: prevFocus,
    obscureText: true,
    enableSuggestions: false,
    autocorrect: false,
    maxLength: Variables.maxLengthPassword,
    textInputAction:
        nextFocus != null ? TextInputAction.next : TextInputAction.done,
    cursorColor: darkTheme ? ThemeColorDark.cursor : ThemeColor.cursor,
    style: TextStyle(
      color: darkTheme ? ThemeColorDark.textPrimary : ThemeColor.textPrimary,
    ),
    decoration: InputDecoration(
      labelText: pwtext,
      labelStyle: TextStyle(
        color: darkTheme ? ThemeColorDark.textPrimary : ThemeColor.textPrimary,
      ),
      enabledBorder: enabledInputBorder(darkTheme),
      focusedBorder: focusedInputBorder(darkTheme),
    ),
    onSubmitted: (v) {
      if (authButton != null) {
        authButton.onPressed!();
        return;
      }
      if (nextFocus != null) {
        FocusScope.of(context).requestFocus(nextFocus);
        return;
      }
    },
  );
}

InputBorder enabledInputBorder(bool darkTheme) {
  return UnderlineInputBorder(
    borderSide: BorderSide(
      color:
          darkTheme ? ThemeColorDark.textSecondary : ThemeColor.textSecondary,
      width: 0.0,
    ),
  );
}

InputBorder focusedInputBorder(bool darkTheme) {
  return UnderlineInputBorder(
    borderSide: BorderSide(
      color:
          darkTheme ? ThemeColorDark.textSecondary : ThemeColor.textSecondary,
      width: 0.0,
    ),
  );
}

RegExp usernameRegExp = RegExp(r'^[A-Za-z0-9_]+$');
