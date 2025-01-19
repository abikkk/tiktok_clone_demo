import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:tiktok_clone_demo/core/constants/constant_variables.dart';
import 'package:tiktok_clone_demo/core/utils/secure_storage_controller.dart';
import 'package:tiktok_clone_demo/core/utils/snackbar.dart';

class AuthService {
  FirebaseAuth fbAuth = FirebaseAuth.instance;

  Future<User?> signIn(
      {bool withEmail = false, String email = '', String password = ''}) async {
    try {
      if (withEmail) {
        await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password);
        return FirebaseAuth.instance.currentUser;
      } else {
        GoogleSignInAccount? account =
            await GoogleSignIn().signIn(); // google sign in prompt
        GoogleSignInAuthentication? auth = await account
            ?.authentication; // get authentication details for the sign in
        AuthCredential credential = GoogleAuthProvider.credential(
            accessToken: auth?.accessToken,
            idToken:
                auth?.idToken); // create a credential for logged in account

        UserCredential userCredential =
            await FirebaseAuth.instance.signInWithCredential(credential);
        return (userCredential.user);
      }
    } catch (e) {
      snackBar().show(
          title: 'Sign-in error', message: 'Could not sign in', isError: true);
      debugPrint('## ERROR LOGGING IN: $e');
      rethrow;
    }
  }

  Future<User?> signUp(
      {required String email, required String password}) async {
    try {
      UserCredential credential = await fbAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      return credential.user;
    } catch (e) {
      snackBar()
          .show(title: 'Sign-up error', message: e.toString(), isError: true);
      debugPrint('## ERROR SIGNING UP: $e');
    }
    return null;
  }

  Future<bool> signOut() async {
    try {
      fbAuth.signOut();
      SecureStorageController().delete(id: savedEmail);
      SecureStorageController().delete(id: savedPassword);
      return true;
    } catch (e) {
      snackBar()
          .show(title: 'Sign-out error', message: e.toString(), isError: true);
      debugPrint('## ERROR SIGNING OUT: $e');
    }
    return false;
  }
}
