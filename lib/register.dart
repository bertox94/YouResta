import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:youresta/model/custom_user.dart';
import 'package:youresta/model/dish.dart';
import 'package:youresta/auth_service.dart';
import 'package:youresta/loading.dart';
import 'package:flutter/material.dart';

import 'commons.dart';

class Register extends StatefulWidget {
  final Function toggleView;

  Register({this.toggleView});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthService _auth = AuthService();
  final formKey = GlobalKey<FormState>();
  String error = '';
  bool loading = false;
  bool isBusiness = false;

  // text field state
  String email = '';
  String password = '';
  String name = '';

  @override
  Widget build(BuildContext context) {
    StreamBuilder buildName() {
      return StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance.collection('custom_users').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return TextFormField(
                validator: (value) {
                  if (value == '') {
                    return 'The name must not be empty';
                  }
                  //eventually register temporarily, or register everyone and add a field in firestore: valid_account, to be checked before login
                  if (snapshot.data.documents.any((x) => (x.data['name']
                              .toString()
                              .trim()
                              .toLowerCase()
                              .compareTo(name.trim().toLowerCase())) ==
                          0
                      ? true
                      : false)) {
                    return 'This name is not available';
                  }

                  return null;
                },
                onChanged: (val) {
                  setState(() => name = val);
                },
                obscureText: false,
                style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 20.0,
                    color: Colors.white),
                decoration: InputDecoration(
                  icon: new Icon(Icons.person),
                  //contentPadding: EdgeInsets.fromLTRB(10.0, 15.0, 20.0, 15.0),
                  hintText: 'User/Restaurant name',
                  hintStyle: TextStyle(fontSize: 20.0, color: Colors.grey),
                  //border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
                ));
          } else {
            return Loading();
          }
        },
      );
    }

    Form buildForm() {
      return Form(
          key: formKey,
          child: Scrollbar(
            child: ListView(
              children: <Widget>[
                SizedBox(height: 210.0),
                buildName(),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Checkbox(
                      value: isBusiness,
                      onChanged: (bool value) {
                        isBusiness = value;
                      },
                    ),
                    Text(
                      "Register as a Restaurant Owner",
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
                //SizedBox(height: 20.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    SizedBox(
                        width: 120,
                        child: RaisedButton(
                          onPressed: () => widget.toggleView(),
                          child: Text("Log In", style: TextStyle(fontSize: 20)),
                          color: Colors.orange,
                          textColor: Colors.white,
                        )),
                    SizedBox(
                        width: 120,
                        child: RaisedButton(
                          onPressed: () async {
                            if (formKey.currentState.validate()) {
                              formKey.currentState.save();
                              setState(() => loading = true);
                              dynamic result =
                                  await _auth.registerWithEmailAndPassword(
                                      email.trim(),
                                      password.trim(),
                                      name.trim(),
                                      isBusiness);

                              if (result == null) {
                                setState(() {
                                  loading = false;
                                  error = 'Please supply a valid email';
                                });
                              }
                            }
                          },
                          child:
                              Text("Register", style: TextStyle(fontSize: 20)),
                          color: Colors.red,
                          textColor: Colors.white,
                        )),
                  ],
                ),
                SizedBox(height: 5.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      error,
                      style: TextStyle(color: Colors.red, fontSize: 14.0),
                    )
                  ],
                ),
                //SizedBox(height: 10.0),
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
