import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:youresta/model/custom_user.dart';
import 'package:youresta/model/dish.dart';
import 'package:youresta/auth_service.dart';
import 'package:youresta/loading.dart';
import 'package:flutter/material.dart';

class Register extends StatefulWidget {
  final Function toggleView;

  Register({this.toggleView});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  String error = '';
  bool loading = false;
  bool isBusiness = false;

  // text field state
  String email = '';
  String password = '';
  String name = '';

  @override
  Widget build(BuildContext context) {
    CustomUser buildUser(DocumentSnapshot doc) {
      return new CustomUser(
          uid: doc.data['uid'],
          name: doc.data['name'],
          isBusiness: doc.data['isBusiness']);
    }

    StreamBuilder buildName() {
      return StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance.collection('custom_users').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List customUsers =
                snapshot.data.documents.map((doc) => buildUser(doc)).toList();

            return TextFormField(
                validator: (value) {
                  if (value == '') {
                    return 'The name must not be empty';
                  }
                  for (int i = 0; i < customUsers.length; i++) {
                    if (value.toLowerCase().trim() ==
                        customUsers.elementAt(i).name.toLowerCase().trim())
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

    TextFormField buildEmail() {
      return TextFormField(
          validator: (val) => val.isEmpty ? 'Enter an email' : null,
          onChanged: (val) {
            setState(() => email = val);
          },
          obscureText: false,
          style: TextStyle(
              fontFamily: 'Montserrat', fontSize: 20.0, color: Colors.white),
          decoration: InputDecoration(
            icon: new Icon(Icons.mail),
            //contentPadding: EdgeInsets.fromLTRB(10.0, 15.0, 20.0, 15.0),
            hintText: 'Email',
            hintStyle: TextStyle(fontSize: 20.0, color: Colors.grey),
            //border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
          ));
    }

    TextFormField buildPassword() {
      return TextFormField(
        validator: (val) =>
            val.length < 6 ? 'Enter a password 6+ chars long' : null,
        onChanged: (val) {
          setState(() => password = val);
        },
        obscureText: true,
        style: TextStyle(
            fontFamily: 'Montserrat', fontSize: 20.0, color: Colors.white),
        decoration: InputDecoration(
          icon: new Icon(Icons.lock),
          //contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Password",
          hintStyle: TextStyle(fontSize: 20.0, color: Colors.grey),
          //border:OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))
        ),
      );
    }

    Form buildForm() {
      return Form(
          key: _formKey,
          child: Scrollbar(
            child: ListView(
              children: <Widget>[
                SizedBox(height: 235.0),
                buildName(),
                buildEmail(),
                buildPassword(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Checkbox(
                      value: isBusiness,
                      onChanged: (bool value) {
                        setState(() {
                          isBusiness = value;
                        });
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
                            if (_formKey.currentState.validate()) {
                              //_formKey.currentState.save();
                              setState(() => loading = true);
                              dynamic result =
                                  await _auth.registerWithEmailAndPassword(
                                      email, password, name.trim(), isBusiness);

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