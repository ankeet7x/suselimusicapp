import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

enum Status { Unauthenticaed, Authenticating, Authenticated }

class DbProvider extends ChangeNotifier {
  Status status = Status.Unauthenticaed;
  User user;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _signIn = GoogleSignIn();

  signInWithGoogle() async {
    try {
      status = Status.Authenticating;
      notifyListeners();
      final GoogleSignInAccount googleSignInAccount = await _signIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
          idToken: googleSignInAuthentication.idToken,
          accessToken: googleSignInAuthentication.accessToken);
      final authResult = await _auth.signInWithCredential(credential);
      user = authResult.user;
      print(user.displayName);
      notifyListeners();
      status = Status.Authenticated;
      notifyListeners();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> signOutWithGoogle() async {
    await _signIn.signOut();
    print("signed out");
  }
}
