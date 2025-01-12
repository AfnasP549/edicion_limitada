import 'dart:developer';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final _auth = FirebaseAuth.instance;

  Stream<User?>get userStream => FirebaseAuth.instance.authStateChanges();

  final GoogleSignIn _googleSignIn = GoogleSignIn();

  //!forgot
  Future<void> sendPasswordResetLink(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      print(e.toString());
    }
  }

 //!Google
  Future<UserCredential?> loginWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;
      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth?.idToken,
        accessToken: googleAuth?.accessToken,
      );
      return await _auth.signInWithCredential(credential);
    } catch (e) {
      print(e.toString());
    }
    return null;
  }

  // //!SignUp
  //   Future<User?> createUserWithEmailAndPass(
  //       String email, String password) async {
  //     try {
  //       final cred = await _auth.createUserWithEmailAndPassword(
  //           email: email, password: password);
  //       return cred.user;
  //     } on FirebaseAuthException catch (e) {
  //       exceptionHandler(e.code);
  //     } catch (e) {
  //       log('$e');
  //     }
  //     return null;
  //   }

 //!Login
  Future<User?> loginUserWithEmailAndPass(String email, String password) async {
    try {
      final cred = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return cred.user;
    } on FirebaseAuthException catch (e) {
      exceptionHandler(e.code);
    }
    return null;
  }

 //!SignOut
  Future<void> signout() async {
    try {
      await _auth.signOut();
    } catch (e) {
      log('$e');
    }
  }
    Future<User?> createUserWithEmailAndPass(String email, String password, String fullName)async{
      try{
        final cred = await _auth.createUserWithEmailAndPassword(email: email, password: password);
        cred.user?.updateDisplayName(fullName);

        await cred.user?.reload();

       return  _auth.currentUser;
      } on FirebaseAuthException catch(e){
        exceptionHandler(e.code);
      }catch(e){
        log('$e');
      }
      return null;
    }
}

exceptionHandler(String code) {
  switch (code) {
    case "invalide-credential":
      log('your login credentials are invalid');
    //your login credentials are invalid

    case "weak-password":
      log('your password must be atleast 8 characters');
    //your password must be atleast 8 characters

    case "email-already-in-use":
      log('User already exist');
    //User already exist
    default:
      log('something went wrong'); //something went wrong
  }
}
