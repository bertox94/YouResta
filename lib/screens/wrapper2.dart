import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:youresta/models/custom_user.dart';
import 'package:youresta/models/user.dart';
import 'package:youresta/services/custom_user_manager.dart';
import 'package:youresta/shared/loading.dart';

import 'home/home_business.dart';
import 'home/home_customer.dart';

class Wrapper2 extends StatelessWidget {
  final FirebaseUser user;

  Wrapper2({this.user});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: CustomUserManager(uid: user.uid).userData,
      builder: (context, snapshot) {
        CustomUser customUser = snapshot.data;

        if (!snapshot.hasData) {
          return Loading();
        } else if (snapshot.hasError) {
          throw new Exception('\nSomething went wrong :(');
        } else if (customUser.isBusiness) {
          return HomeBusiness();
        } else {
          return HomeCustomer(customUser: customUser,firebaseUser: user,);
        }
      },
    );
  }
}
