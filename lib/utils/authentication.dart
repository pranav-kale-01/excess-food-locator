import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:food_app/screens/home_screen.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Authentication {
  static SnackBar customSnackBar({required String content}) {
    return SnackBar(
      backgroundColor: Colors.black,
      content: Text(
        content,
        style: const TextStyle(color: Colors.redAccent, letterSpacing: 0.5),
      ),
    );
  }

  static Future<FirebaseApp> initializeFirebase() async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();

    return firebaseApp;
  }

  static Future<void> signOut({required BuildContext context}) async {
    final GoogleSignIn googleSignIn = GoogleSignIn();

    try {
      if (!kIsWeb) {
        await googleSignIn.signOut();
      }
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        Authentication.customSnackBar(
          content: 'Error signing out. Try again.',
        ),
      );
    }
  }


  static Future<User?> signInWithGoogle({required BuildContext context}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;

    if (kIsWeb) {
      GoogleAuthProvider authProvider = GoogleAuthProvider();

      try {
        final UserCredential userCredential =
        await auth.signInWithPopup(authProvider);

        user = userCredential.user;
      } catch (e,s ) {
        debugPrint( e.toString() );
        debugPrint( s.toString() );
      }
    } else {
      final GoogleSignIn googleSignIn = GoogleSignIn();

      final GoogleSignInAccount? googleSignInAccount =
      await googleSignIn.signIn();

      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        try {
          final UserCredential userCredential =
          await auth.signInWithCredential(credential);

          user = userCredential.user;
        } on FirebaseAuthException catch (e) {
          if (e.code == 'account-exists-with-different-credential') {
            ScaffoldMessenger.of(context).showSnackBar(
              Authentication.customSnackBar(
                content:
                'The account already exists with a different credential',
              ),
            );
          } else if (e.code == 'invalid-credential') {
            ScaffoldMessenger.of(context).showSnackBar(
              Authentication.customSnackBar(
                content:
                'Error occurred while accessing credentials. Try again.',
              ),
            );
          }
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            Authentication.customSnackBar(
              content: 'Error occurred using Google Sign In. Try again.',
            ),
          );
        }
      }
    }

    return user;
  }

  static Future<User?> signInSilently({required BuildContext context}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;

    if (kIsWeb) {
      GoogleAuthProvider authProvider = GoogleAuthProvider();

      try {
        final UserCredential userCredential =
        await auth.signInWithPopup(authProvider);

        user = userCredential.user;
      } catch (e,s ) {
        debugPrint( e.toString() );
        debugPrint( s.toString() );
      }
    } else {
      final GoogleSignIn googleSignIn = GoogleSignIn();

      final GoogleSignInAccount? googleSignInAccount =
      await googleSignIn.signInSilently();

      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        try {
          final UserCredential userCredential =
          await auth.signInWithCredential(credential);

          user = userCredential.user;
        } on FirebaseAuthException catch (e) {
          if (e.code == 'account-exists-with-different-credential') {
            ScaffoldMessenger.of(context).showSnackBar(
              Authentication.customSnackBar(
                content:
                'The account already exists with a different credential',
              ),
            );
          } else if (e.code == 'invalid-credential') {
            ScaffoldMessenger.of(context).showSnackBar(
              Authentication.customSnackBar(
                content:
                'Error occurred while accessing credentials. Try again.',
              ),
            );
          }
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            Authentication.customSnackBar(
              content: 'Error occurred using Google Sign In. Try again.',
            ),
          );
        }
      }
    }

    return user;
  }
}