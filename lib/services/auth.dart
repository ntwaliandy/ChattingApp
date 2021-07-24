//@dart=2.9
import 'package:chatapp_draft/services/user.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  //create user object in firebase
  UserF _userFromFirebaseUser(User user) {
    return user != null ? UserF(uid: user.uid) : null;
  }

  //auth change user stream
  Stream<UserF> get user {
    return _auth.authStateChanges().map(_userFromFirebaseUser);
  }

  //register with email and password
  Future registerWithEmailAndPassoword(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User user = result.user;
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //sign in with email and password
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User user = result.user;
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //signout
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
