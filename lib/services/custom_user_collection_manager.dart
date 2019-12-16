import 'package:flutter/gestures.dart';
import 'package:youresta/models/brew.dart';
import 'package:youresta/models/custom_user.dart';
import 'package:youresta/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CustomUserCollectionManager {
  // collection reference
  final CollectionReference customUserCollection =
      Firestore.instance.collection('custom_users');

  Future<void> updateUserData(String uid, String name, bool isBusiness) async {
    return await customUserCollection.document(uid).setData({
      'uid': uid,
      'name': name,
      'isBusiness': isBusiness,
    });
  }

  // user data from snapshots
  CustomUser _userDataFromSnapshot(DocumentSnapshot snapshot) {
    return CustomUser(
        uid: snapshot.documentID, isBusiness: snapshot.data['isBusiness']);
  }

  Future<void> deleteUser(String uid) async {
    return await customUserCollection.document(uid).delete();
  }

// get user doc stream
//simply put customusercollection n value of streambuilder

}
