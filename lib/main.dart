import 'package:youresta/screens/home/home_business.dart';
import 'package:youresta/screens/wrapper.dart';
import 'package:youresta/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youresta/models/user.dart';
import 'package:youresta/shared/loading.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Wrapper(),
    );
  }
}
