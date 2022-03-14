import 'package:auth_buttons/auth_buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../utils/colors.dart';

TextField emailTextField(
    {required BuildContext context,
    required TextEditingController emailController,
    CustomAuthButton? authButton,
    FocusNode? prevFocus,
    FocusNode? nextFocus}) {
  return TextField(
    controller: emailController,
    focusNode: prevFocus,
    keyboardType: TextInputType.emailAddress,
    textInputAction:
        nextFocus != null ? TextInputAction.next : TextInputAction.done,
    cursorColor: ThemeColor.cursor,
    decoration: InputDecoration(
      labelText: AppLocalizations.of(context).email,
      labelStyle: const TextStyle(
        color: ThemeColor.textPrimary,
      ),
      enabledBorder: enabledInputBorder(),
      focusedBorder: focusedInputBorder(),
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

TextField customTextField(
    {required BuildContext context,
    required String labelText,
    required TextEditingController nameController,
    CustomAuthButton? authButton,
    FocusNode? prevFocus,
    FocusNode? nextFocus}) {
  return TextField(
    controller: nameController,
    focusNode: prevFocus,
    keyboardType: TextInputType.name,
    textInputAction:
        nextFocus != null ? TextInputAction.next : TextInputAction.done,
    cursorColor: ThemeColor.cursor,
    decoration: InputDecoration(
      labelText: labelText,
      labelStyle: const TextStyle(
        color: ThemeColor.textPrimary,
      ),
      enabledBorder: enabledInputBorder(),
      focusedBorder: focusedInputBorder(),
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

TextField passwordTextField(
    {required BuildContext context,
    required String pwtext,
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
    textInputAction:
        nextFocus != null ? TextInputAction.next : TextInputAction.done,
    cursorColor: ThemeColor.cursor,
    decoration: InputDecoration(
      labelText: pwtext,
      labelStyle: const TextStyle(
        color: ThemeColor.textPrimary,
      ),
      enabledBorder: enabledInputBorder(),
      focusedBorder: focusedInputBorder(),
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

InputBorder enabledInputBorder() {
  return const UnderlineInputBorder(
    borderSide: BorderSide(
      color: ThemeColor.textSecondary,
      width: 0.0,
    ),
  );
}

InputBorder focusedInputBorder() {
  return const UnderlineInputBorder(
    borderSide: BorderSide(
      color: ThemeColor.textSecondary,
      width: 0.0,
    ),
  );
}

RegExp usernameRegExp = RegExp(r'^[A-Za-z0-9_]+$');
