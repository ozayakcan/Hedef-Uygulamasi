import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:hedef/utils/widgets.dart';

void loginError(BuildContext context, FirebaseAuthException e) {
  ScaffoldSnackbar.of(context).show('Giriş Başarısız! ${e.message}');
  if (kDebugMode) {
    print('Giriş Başarısız! Kod: ${e.code}');
    print(e.message);
  }
}
