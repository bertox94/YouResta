import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  static Future standardSignIn() async {
    try {
      return await _auth.signInWithEmailAndPassword(
          email: 'standard@youresta.com', password: '1234567890');
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  // sign in with email and password
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser user = result.user;
      return user;
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  // register with email and password
  dynamic registerWithEmailAndPassword(
      String email, String password, String name, bool isBusiness) async {
    try {
      AuthResult result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser user = result.user;

      await Firestore.instance
          .collection('custom_users')
          .document(user.uid)
          .setData({
        'uid': user.uid,
        'name': name,
        'isBusiness': isBusiness,
      });

      return user;
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  // sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (error) {
      print(error.toString());
      return null;
    }
  }
}
