import 'package:youresta/models/custom_user.dart';
import 'package:youresta/models/user.dart';
import 'package:youresta/screens/authenticate/authenticate.dart';
import 'package:youresta/screens/home/home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youresta/services/custom_user_manager.dart';
import 'package:youresta/shared/loading.dart';

class Wrapper2 extends StatelessWidget {
  final User user;

  Wrapper2({this.user});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<CustomUser>(
        stream: CustomUserManager(uid: user.uid).userData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            CustomUser userData = snapshot.data;
            if (userData.isBusiness) {
              return Text('Business');
            } else {
              return Text('NonBusiness');
            }
          } else {
            return Home();
          }
        });
  }
}
