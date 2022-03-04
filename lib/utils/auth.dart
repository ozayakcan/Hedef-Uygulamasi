import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hedef/utils/errors.dart';

class Auth {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static get user => _auth.currentUser;

  static Future signInWithGoogle() async {
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
      return firebaseAuthMessages(e.code);
    }
  }

  static Future signInWithGoogleWeb() async {
    try {
      GoogleAuthProvider googleProvider = GoogleAuthProvider();

      await _auth.signInWithPopup(googleProvider);
      //await _auth.signInWithRedirect(googleProvider);
      return null;
    } on FirebaseAuthException catch (e) {
      return firebaseAuthMessages(e.code);
    }
  }

  static Future signupWithEmail(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return null;
    } on FirebaseAuthException catch (e) {
      return firebaseAuthMessages(e.code);
    }
  }

  static Future signInWithEmail(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return null;
    } on FirebaseAuthException catch (e) {
      return firebaseAuthMessages(e.code);
    }
  }
}
