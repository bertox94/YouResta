import 'package:youresta/models/user.dart';
import 'package:youresta/screens/authenticate/authenticate.dart';
import 'package:youresta/screens/home/home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youresta/screens/wrapper2.dart';
import 'package:youresta/shared/loading.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    // return either the Home or Authenticate widget
    if (user == null) {
      return Authenticate();
    } else {
      return Wrapper2(user: user);
    }
  }
}
