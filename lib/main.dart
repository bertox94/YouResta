import 'package:youresta/home_business.dart';
import 'package:youresta/home_customer.dart';
import 'package:youresta/wrapper.dart';
import 'package:youresta/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youresta/loading.dart';

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
