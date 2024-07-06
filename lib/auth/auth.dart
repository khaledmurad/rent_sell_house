import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';

abstract class AuthBase {
  User get currentUser;
  Stream<User> authStateChanges();
  Future<User> signInAnonymously();
  Future<User> signInWithEmailandPassword(String email ,String password);
  Future<User> CreateUserWithEmailandPassword(String email ,String password);
  Future<User> signInWithGoogle();
  Future<User> signInWithFacebook();
  Future<void> signOut();

}


class Auth implements AuthBase {
  final _firebaseAuth = FirebaseAuth.instance;

  @override
  Stream<User> authStateChanges() => _firebaseAuth.authStateChanges();

  @override
  User get currentUser => _firebaseAuth.currentUser;

  @override
  Future<User> signInAnonymously() async {
    final userCredintial = await _firebaseAuth.signInAnonymously();
    // FirebaseFirestore.instance
    //     .collection('Users')
    //     .doc(currentUser.uid)
    //     .set({
    //   "id":FirebaseAuth.instance.currentUser.uid,
    // });
    return userCredintial.user;
  }

  @override
  Future<User> signInWithEmailandPassword(String email ,String password) async {
    final userCredintial = await _firebaseAuth.signInWithCredential(EmailAuthProvider
        .credential(email : email ,password : password));
    return userCredintial.user;
  }

  @override
  Future<User> CreateUserWithEmailandPassword(String email ,String password) async {
    final userCredintial = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    return userCredintial.user;
  }

  @override
  Future<User> signInWithGoogle() async {
    final googleSignIn = GoogleSignIn();
    final googleUser = await googleSignIn.signIn();
    if (googleUser != null) {
      final googleAuth = await googleUser.authentication;
      if (googleAuth.idToken != null) {
        final userGredential = await _firebaseAuth.signInWithCredential(
            GoogleAuthProvider.credential(
                idToken: googleAuth.idToken,
                accessToken: googleAuth.accessToken));
        return userGredential.user;
      }else {
        throw FirebaseAuthException(
            code: 'ERROR_MISSING_GOOGLE_ID_TOKEN',
            message:'Missing Google ID Token'
        );
      }
    }else{
      throw FirebaseAuthException(
          code: 'ERROR_ABORTED_BY_USER',
          message: 'Sign in aborted by user'
      );
    }
  }
  @override
  Future<User> signInWithFacebook() async{
    final fb = FacebookLogin();
    final response = await fb.logIn(permissions: [
      FacebookPermission.email,
      FacebookPermission.publicProfile,
      FacebookPermission.userFriends
    ]);
    switch(response.status){
      case FacebookLoginStatus.success:
        final accessToken=response.accessToken;
        final userCredential = await _firebaseAuth.signInWithCredential(
            FacebookAuthProvider.credential(accessToken.token)
        );return userCredential.user;
      case FacebookLoginStatus.cancel:
        throw FirebaseAuthException(
            code: 'ERROR_ABORTED_BY_USER',
            message: 'Sign in aborted by user'
        );
      case FacebookLoginStatus.error:
        throw FirebaseAuthException(
            code: 'ERROR_FACEBOOK_LOGIN_FAILED',
            message:response.error.developerMessage
        );
      default:
        throw UnimplementedError();
    }
  }


  @override
  Future<void> signOut() async {
    final googleSignIn = GoogleSignIn();
    await googleSignIn.signOut();
    final facebookLogin = FacebookLogin();
    await facebookLogin.logOut();
    await _firebaseAuth.signOut();
  }

//  Future<bool> validatePassword(String currentPass) async {
//    var authCredential = EmailAuthProvider.credential(email: currentUser.email, password: currentPass);
//   try{
//
//     var authResult = await currentUser.reauthenticateWithCredential(
//       EmailAuthProvider.getCredential(
//         email: currentUser.email,
//         password: currentPass,
//       ),
//     );
//
//// Then use the newly re-authenticated user
//     authResult;
//
//   }catch(e){
//     print(e.toString());
//     return false;
//   }
//
//  }


}
