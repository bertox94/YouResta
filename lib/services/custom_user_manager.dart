import 'package:flutter/gestures.dart';
import 'package:youresta/models/brew.dart';
import 'package:youresta/models/custom_user.dart';
import 'package:youresta/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CustomUserManager {
  final String uid;

  CustomUserManager({this.uid});

  // collection reference
  final CollectionReference customUserCollection =
      Firestore.instance.collection('custom_users');

  Future<void> updateUserData(String name, bool isBusiness) async {
    return await customUserCollection.document(uid).setData({
      'uid': uid,
      'name': name,
      'isBusiness': isBusiness,
    });
  }


  Future<void> deleteUser() async {
    return await customUserCollection.document(uid).delete();
  }

  // get user doc stream
  Stream<CustomUser> get userData {
    return customUserCollection.document(uid).snapshots().map((doc) =>
        (new CustomUser(
            name: doc['name'], uid: uid, isBusiness: doc['isBusiness'])));
  }
}
