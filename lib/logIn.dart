import 'package:flutter/material.dart';
import 'package:youresta/homeStful.dart';
import 'package:youresta/homeStless.dart';

class LogIn extends StatefulWidget {
  LogIn({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.
  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".
  final String title;

  @override
  _LogInState createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {

    final loginButton = RaisedButton(
      onPressed: () {},
      textColor: Colors.white,
      padding: const EdgeInsets.all(0.0),
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: <Color>[
              Colors.orange,
              Colors.red,
            ],
          ),
        ),
        padding: const EdgeInsets.all(10.0),
        child: const Text('Gradient Button', style: TextStyle(fontSize: 20)),
      ),
    );

  }
}
