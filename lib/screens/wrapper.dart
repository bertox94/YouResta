import 'package:firebase_auth/firebase_auth.dart';
import 'package:youresta/screens/authenticate/authenticate.dart';
import 'package:flutter/material.dart';
import 'package:youresta/screens/wrapper2.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.onAuthStateChanged,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Wrapper2(user: snapshot.data);
        } else {
          return Authenticate();
        }
      },
    );
  }
}
