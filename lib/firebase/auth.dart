import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../utils/errors.dart';

class Auth {
  get user => auth.currentUser;

  Auth(this.auth);

  static Auth of() {
    FirebaseAuth auth = FirebaseAuth.instance;
    return Auth(auth);
  }

  final FirebaseAuth auth;

  void setLanguageCode(BuildContext context) {
    auth.setLanguageCode(AppLocalizations.of(context).localeName);
  }

  Future signInWithGoogle(BuildContext context) async {
    try {
      setLanguageCode(context);
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

  Future signInWithGoogleWeb(BuildContext context) async {
    try {
      setLanguageCode(context);
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

  Future signupWithEmail(
      BuildContext context, String email, String name, String password) async {
    try {
      setLanguageCode(context);
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      changeDisplayName(
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

  Future signInWithEmail(
      BuildContext context, String email, String password) async {
    try {
      setLanguageCode(context);
      await auth.signInWithEmailAndPassword(email: email, password: password);
      return null;
    } on FirebaseAuthException catch (e) {
      return firebaseAuthMessages(context, e.code);
    }
  }

  Future sendEmailVerification(BuildContext context) async {
    try {
      setLanguageCode(context);
      await user.sendEmailVerification();
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  Future resetPassword(BuildContext context, String email) async {
    try {
      setLanguageCode(context);
      await auth.sendPasswordResetEmail(email: email);
      return null;
    } on FirebaseAuthException catch (e) {
      return firebaseAuthMessages(context, e.code);
    }
  }

  Future changeDisplayName(BuildContext context, String name,
      {UserCredential? userCredential, User? user}) async {
    if (userCredential != null || user != null) {
      try {
        setLanguageCode(context);
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

  void signOut() {
    auth.signOut();
  }
}
