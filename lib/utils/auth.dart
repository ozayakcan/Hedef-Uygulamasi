import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Auth {
  static Future<UserCredential> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  static Future<UserCredential> signInWithGoogleWeb() async {
    GoogleAuthProvider googleProvider = GoogleAuthProvider();

    return await FirebaseAuth.instance.signInWithPopup(googleProvider);
    // return await FirebaseAuth.instance.signInWithRedirect(googleProvider);
  }
}
