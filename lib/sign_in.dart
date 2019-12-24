import 'package:youresta/auth_service.dart';
import 'package:youresta/loading.dart';
import 'package:flutter/material.dart';

import 'commons.dart';

class SignIn extends StatefulWidget {
  final Function toggleView;

  SignIn({this.toggleView});

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _auth = AuthService();
  final formKey = GlobalKey<FormState>();
  String error = '';
  bool loading = false;
  bool isBusiness = false;

  // text field state
  String email = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    Form buildForm() {
      return Form(
          key: formKey,
          child: Scrollbar(
            child: ListView(
              children: <Widget>[
                SizedBox(height: 240.0),
                Commons.buildEmail(
                  (val) {
                    email = val;
                  },
                ),
                Commons.buildPassword(
                  (val) {
                    password = val;
                  },
                ),
                SizedBox(height: 10.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      error,
                      style: TextStyle(color: Colors.red, fontSize: 14.0),
                    )
                  ],
                ),
                SizedBox(height: 15.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    SizedBox(
                        width: 120,
                        child: RaisedButton(
                          onPressed: () async {
                            if (formKey.currentState.validate()) {
                              formKey.currentState.save();
                              setState(() => loading = true);
                              dynamic result =
                                  await _auth.signInWithEmailAndPassword(
                                      email.trim(), password.trim());
                              if (result == null) {
                                setState(() {
                                  loading = false;
                                  error =
                                      'Could not sign in with those credentials';
                                });
                              }
                            }
                          },
                          child: Text("Log In", style: TextStyle(fontSize: 20)),
                          color: Colors.orange,
                          textColor: Colors.white,
                        )),
                  ],
                ),
                Container(
                  alignment: Alignment(0, 0),
                  margin: EdgeInsets.all(5),
                  child: Text(
                    'OR',
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    SizedBox(
                        width: 120,
                        child: RaisedButton(
                          onPressed: () => widget.toggleView(),
                          child:
                              Text("Register", style: TextStyle(fontSize: 20)),
                          color: Colors.red,
                          textColor: Colors.white,
                        )),
                  ],
                ),
                SizedBox(height: 5.0),
                SizedBox(height: 10.0),
              ],
            ),
          ));
    }

    return loading
        ? Loading()
        : Scaffold(
            body: Container(
                decoration: BoxDecoration(
                  // Box decoration takes a gradient
                  gradient: LinearGradient(
                    // Where the linear gradient begins and ends
                    end: Alignment.topRight,
                    begin: Alignment.bottomLeft,
                    // Add one stop for each color. Stops should increase from 0 to 1
                    stops: [0.1, 0.5, 0.7, 0.9],
                    colors: [
                      // Colors are easy thanks to Flutter's Colors class.
                      Colors.indigo[800],
                      Colors.indigo[700],
                      Colors.indigo[600],
                      Colors.indigo[400],
                    ],
                  ),
                ),
                padding: EdgeInsets.fromLTRB(30.0, 45, 30, 0),
                child: Stack(children: <Widget>[
                  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Opacity(
                          opacity: 0.65,
                          //duration: Duration(seconds: 10),
                          child: Image.asset(
                            'assets/logo.png',
                            scale: 5,
                          ),
                        )
                      ]),
                  buildForm(),
                ])),
          );
  }
}
