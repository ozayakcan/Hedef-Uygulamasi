import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hedef/utils/errors.dart';

class Auth {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static get user => _auth.currentUser;

  static Future<UserCredential> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    return await _auth.signInWithCredential(credential);
  }

  static Future<UserCredential> signInWithGoogleWeb() async {
    GoogleAuthProvider googleProvider = GoogleAuthProvider();

    return await _auth.signInWithPopup(googleProvider);
    // return await _auth.signInWithRedirect(googleProvider);
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
