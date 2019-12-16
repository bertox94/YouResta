import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:youresta/shared/loading.dart';

import 'home/home_business.dart';
import 'home/home_customer.dart';

class Wrapper2 extends StatelessWidget {
  final FirebaseUser user;

  Wrapper2({this.user});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Firestore.instance.collection('custom_users').snapshots(),
      builder: (context, snapshot) {
        var selected;

        if (!snapshot.hasData) {
          return Loading();
        } else {
          var documents = snapshot.data.documents;
          for (int i = 0; i < documents.length; i++) {
            print(documents[i]['uid']);
            if (documents[i]['uid'] == user.uid) {
              selected = documents[i];
            }
          }

          if (selected == null) {
            throw new Exception('Something went wrong :(');
          } else if (selected['isBusiness']) {
            return HomeBusiness();
          } else {
            return HomeCustomer();
          }
        }
      },
    );
  }
}
