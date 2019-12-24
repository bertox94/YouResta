import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:youresta/authenticate.dart';
import 'package:flutter/material.dart';
import 'package:youresta/home_customer.dart';

import 'home_business.dart';
import 'loading.dart';
import 'model/custom_user.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.onAuthStateChanged,
      builder: (context, snapshot) {
        FirebaseUser fUser = snapshot.data;

        if (snapshot.hasData) {
          return StreamBuilder<QuerySnapshot>(
              stream: Firestore.instance.collection('custom_users').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  CustomUser customUser = snapshot.data.documents
                      .where((x) =>
                          (x.data['uid'].trim().compareTo(fUser.uid.trim())) ==
                                  0
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
        } else {
          return Authenticate();
        }
      },
    );
  }
}
