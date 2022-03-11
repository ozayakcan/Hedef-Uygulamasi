import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'errors.dart';

class Auth {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static get user => _auth.currentUser;

  static Future signInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      await _auth.signInWithCredential(credential);
      return null;
    } on FirebaseAuthException catch (e) {
      return firebaseAuthMessages(context, e.code);
    }
  }

  static Future signInWithGoogleWeb(BuildContext context) async {
    try {
      GoogleAuthProvider googleProvider = GoogleAuthProvider();

      await _auth.signInWithPopup(googleProvider);
      //await _auth.signInWithRedirect(googleProvider);
      return null;
    } on FirebaseAuthException catch (e) {
      return firebaseAuthMessages(context, e.code);
    }
  }

  static Future signupWithEmail(
      BuildContext context, String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return null;
    } on FirebaseAuthException catch (e) {
      return firebaseAuthMessages(context, e.code);
    }
  }

  static Future signInWithEmail(
      BuildContext context, String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return null;
    } on FirebaseAuthException catch (e) {
      return firebaseAuthMessages(context, e.code);
    }
  }

  static Future sendEmailVerification(BuildContext context) async {
    try {
      _auth.setLanguageCode(AppLocalizations.of(context).localeName);
      final user = FirebaseAuth.instance.currentUser!;
      await user.sendEmailVerification();
      return null;
    } catch (e) {
      return e.toString();
    }
  }
}
