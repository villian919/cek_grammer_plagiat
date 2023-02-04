import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Auth extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  get user => _auth.currentUser;

//SIGN UP METHOD
  Future<String?> signUp(
      {required String email, required String password}) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  //SIGN IN METHODJ
  Future<String?> signIn(
      {required String email, required String password}) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  //SIGN OUT METHOD
  Future<void> signOut() async {
    await _auth.signOut();

    googleSignIn.signOut();

    log('signout');
  }

  //SEND LINK TO EMAIL METHOD
  Future<String?> sendPass({required String email}) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  //reauth
  Future<String?> reauth({required String email, required password}) async {
    try {
      _auth.currentUser?.reauthenticateWithCredential(
          EmailAuthProvider.credential(email: email, password: password));
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  //updateemail
  Future<String?> updateEmail({required String email}) async {
    try {
      _auth.currentUser?.updateEmail(email);
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
    return null;
  }

  //updateemail
  Future<String?> updatePassword({required String password}) async {
    try {
      _auth.currentUser?.updatePassword(password);
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
    return null;
  }

//userChanges
  Future<String?> userChanges(
      {required String email,
      required String password,
      required String setPassword}) async {
    user.updatePassword(password).then((_) {
      FirebaseAuth.instance.authStateChanges().listen((User? user) {
        if (user == null) {
          log('User is currently signed out!');
        } else {
          log('User password update');
        }
      });
      log("User password update");
    });
    try {
      final emailChange = EmailAuthProvider.credential(
          email: _auth.currentUser!.email.toString(), password: setPassword);

      user.reauthenticateWithCredential(emailChange).then((value) {
        user.updateEmail(email).then((_) {
          FirebaseAuth.instance.authStateChanges().listen((User? user) {
            if (user == null) {
              log('User is currently signed out!');
            } else {
              log('User email update');
            }
          });
          log("User email update Succes");
        });
      });
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
    return null;
  }

  //token
  Future<void> idToken() async {
    user.idTokenChanges().listen((User? user) {
      if (user == null) {
        log('User is currently signed out!');
      } else {
        log('gogo login');
      }
    });
  }

  Future<User?> signInWithGoogle() async {
    User? user;
    if (kIsWeb) {
      GoogleAuthProvider authProvider = GoogleAuthProvider();

      try {
        final UserCredential userCredential =
            await _auth.signInWithPopup(authProvider);

        user = userCredential.user;
      } catch (e) {
        print(e);
      }
    } else {
      try {
        final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

        // Obtain the auth details from the request
        final GoogleSignInAuthentication? googleAuth =
            await googleUser?.authentication;

        // Create a new credential
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth?.accessToken,
          idToken: googleAuth?.idToken,
        );

        // Once signed in, return the UserCredential
        final adndro =
            await FirebaseAuth.instance.signInWithCredential(credential);

        user = adndro.user;
      } catch (e) {
        print(e);
      }
    }
  }

  static SnackBar customSnackBar({required String content}) {
    return SnackBar(
      backgroundColor: Colors.black,
      content: Text(
        content,
        style: const TextStyle(color: Colors.redAccent, letterSpacing: 0.5),
      ),
    );
  }

  Future<User?> signInWithGoogle2({required BuildContext context}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;

    if (kIsWeb) {
      GoogleAuthProvider authProvider = GoogleAuthProvider();

      try {
        final UserCredential userCredential =
            await auth.signInWithPopup(authProvider);

        user = userCredential.user;
      } catch (e) {
        print(e);
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
            // ignore: use_build_context_synchronously
            ScaffoldMessenger.of(context).showSnackBar(
              Auth.customSnackBar(
                content:
                    'The account already exists with a different credential',
              ),
            );
          } else if (e.code == 'invalid-credential') {
            ScaffoldMessenger.of(context).showSnackBar(
              Auth.customSnackBar(
                content:
                    'Error occurred while accessing credentials. Try again.',
              ),
            );
          }
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            Auth.customSnackBar(
              content: 'Error occurred using Google Sign In. Try again.',
            ),
          );
        }
      }
    }

    return user;
  }
}
