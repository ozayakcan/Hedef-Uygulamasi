import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../utils/errors.dart';

class Auth {
  static final FirebaseAuth auth = FirebaseAuth.instance;
  static get user => auth.currentUser;

  static Future signInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      UserCredential userCredential =
          await auth.signInWithCredential(credential);
      if (googleUser != null) {
        changeDisplayName(
          context,
          googleUser.displayName.toString(),
          userCredential: userCredential,
        ).then((value) {
          if (value == null) {
            if (kDebugMode) {
              print("Kullanıcı adı güncellendi.");
            }
          } else {
            if (kDebugMode) {
              print("Kullanıcı adı güncellenemedi. Hata: " + value);
            }
          }
        });
      }
      return null;
    } on FirebaseAuthException catch (e) {
      return firebaseAuthMessages(context, e.code);
    }
  }

  static Future signInWithGoogleWeb(BuildContext context) async {
    try {
      GoogleAuthProvider googleProvider = GoogleAuthProvider();

      UserCredential userCredential =
          await auth.signInWithPopup(googleProvider);
      //await auth.signInWithRedirect(googleProvider);
      if (userCredential.user != null) {
        changeDisplayName(
          context,
          userCredential.user!.displayName.toString(),
          userCredential: userCredential,
        ).then((value) {
          if (value == null) {
            if (kDebugMode) {
              print("Kullanıcı adı güncellendi.");
            }
          } else {
            if (kDebugMode) {
              print("Kullanıcı adı güncellenemedi. Hata: " + value);
            }
          }
        });
      }
      return null;
    } on FirebaseAuthException catch (e) {
      return firebaseAuthMessages(context, e.code);
    }
  }

  static Future signupWithEmail(
      BuildContext context, String email, String name, String password) async {
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      Auth.changeDisplayName(
        context,
        name,
        userCredential: userCredential,
      ).then((value) {
        if (value == null) {
          if (kDebugMode) {
            print("Kullanıcı adı güncellendi.");
            return;
          }
        } else {
          if (kDebugMode) {
            print("Kullanıcı adı güncellenemedi. Hata: " + value);
          }
        }
      });
      return null;
    } on FirebaseAuthException catch (e) {
      return firebaseAuthMessages(context, e.code);
    }
  }

  static Future signInWithEmail(
      BuildContext context, String email, String password) async {
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
      return null;
    } on FirebaseAuthException catch (e) {
      return firebaseAuthMessages(context, e.code);
    }
  }

  static Future sendEmailVerification(BuildContext context) async {
    try {
      auth.setLanguageCode(AppLocalizations.of(context).localeName);
      final user = FirebaseAuth.instance.currentUser!;
      await user.sendEmailVerification();
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  static Future resetPassword(BuildContext context, String email) async {
    try {
      auth.setLanguageCode(AppLocalizations.of(context).localeName);
      await auth.sendPasswordResetEmail(email: email);
      return null;
    } on FirebaseAuthException catch (e) {
      return firebaseAuthMessages(context, e.code);
    }
  }

  static Future changeDisplayName(BuildContext context, String name,
      {UserCredential? userCredential, User? user}) async {
    if (userCredential != null || user != null) {
      try {
        if (user != null) {
          await user.updateDisplayName(name);
          return null;
        }
        if (userCredential != null) {
          await userCredential.user!.updateDisplayName(name);
          return null;
        }
      } on FirebaseAuthException catch (e) {
        return firebaseAuthMessages(context, e.code);
      }
    } else {
      return "Kullanıcı adı güncellenemedi.";
    }
  }

  static Future<User?> getUser(FirebaseAuth auth) async {
    return auth.currentUser;
  }
}
