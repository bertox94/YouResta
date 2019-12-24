import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:youresta/custom_user.dart';
import 'package:youresta/loading.dart';

import 'home_business.dart';
import 'home_customer.dart';

class Wrapper2 extends StatelessWidget {
  final FirebaseUser user;

  Wrapper2({this.user});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance.collection('custom_users').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            CustomUser customUser = snapshot.data.documents
                .where((x) =>
                    (x.data['uid'].trim().compareTo(user.uid.trim())) == 0
                        ? true
                        : false)
                .map((doc) => new CustomUser(
                    isBusiness: doc.data['isBusiness'],
                    uid: doc.data['uid'],
                    name: doc.data['name']))
                .first;

            if (customUser != null) {
              if (customUser.isBusiness) {
                return HomeBusiness(user: customUser);
              } else {
                return HomeCustomer(customUser: customUser);
              }
            }
          } else if (snapshot.hasError) {
            throw new Exception('\nStream had an error :(');
          }
          return Loading();
        });
  }
}
