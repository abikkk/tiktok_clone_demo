import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:tiktok_clone_demo/core/utils/snackbar.dart';

class AuthService {
  FirebaseAuth fbAuth = FirebaseAuth.instance;

  Future<User?> signIn() async {
    try {
      GoogleSignInAccount? account =
          await GoogleSignIn().signIn(); // google sign in prompt
      GoogleSignInAuthentication? auth = await account
          ?.authentication; // get authentication details for the sign in
      AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: auth?.accessToken,
          idToken: auth?.idToken); // create a credential for logged in account

      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      return (userCredential.user);
    } catch (e) {
      snackbar().show(title: 'Sign-in error', message: e.toString());
      debugPrint('## ERROR LOGGING IN: $e');
    }
    return null;
  }

  Future<User?> signUp(
      {required String email, required String password}) async {
    try {
      UserCredential credential = await fbAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      return credential.user;
    } catch (e) {
      snackbar().show(title: 'Sign-up error', message: e.toString());
      debugPrint('## ERROR SIGNING UP: $e');
    }
    return null;
  }

  Future<bool> signOut() async {
    try {
      fbAuth.signOut();
      return true;
    } catch (e) {
      snackbar().show(title: 'Sign-out error', message: e.toString());
      debugPrint('## ERROR SIGNING OUT: $e');
    }
    return false;
  }
}
