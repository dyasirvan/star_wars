
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:star_wars/ui/home.dart';

class AuthServices{
  static FirebaseAuth _auth = FirebaseAuth.instance;
  static GoogleSignIn googleSignIn = GoogleSignIn();

  static Future<FirebaseApp> initializeFirebase({
    required BuildContext context,
  }) async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();

    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => HomePage(),
        ),
      );
    }

    return firebaseApp;
  }

  static Future<User?> signInWithGoogle({required BuildContext context}) async{
    User? user;
    try {
      final GoogleSignInAccount? googleSignInAccount = await googleSignIn
          .signIn();
      final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount!
          .authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
          idToken: googleSignInAuthentication.idToken,
          accessToken: googleSignInAuthentication.accessToken);
      final UserCredential userCredential = await _auth.signInWithCredential(credential);

      user = userCredential.user;
    }catch(e){
      ScaffoldMessenger.of(context).showSnackBar(
        AuthServices.customSnackBar(
          content: e.toString()
          // content: 'Error occurred using Google Sign-In. Try again.',
        ),
      );
    }
    return user;
  }

  static Future<void> signOut({required BuildContext context}) async{
    try{
      await googleSignIn.signOut();
      await _auth.signOut();
    }catch(e){
      ScaffoldMessenger.of(context).showSnackBar(
        AuthServices.customSnackBar(
          content: 'Error occurred using Google Sign-In. Try again.',
        ),
      );
    }
  }

  static SnackBar customSnackBar({required String content}) {
    return SnackBar(
      backgroundColor: Colors.black,
      content: Text(
        content,
        style: TextStyle(color: Colors.redAccent, letterSpacing: 0.5),
      ),
    );
  }
}