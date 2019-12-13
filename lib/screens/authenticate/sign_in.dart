import 'package:youresta/services/auth.dart';
import 'package:youresta/shared/constants.dart';
import 'package:youresta/shared/loading.dart';
import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {
  final Function toggleView;

  SignIn({this.toggleView});

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  String error = '';
  bool loading = false;

  // text field state
  String email = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);

    final EmailField = TextFormField(
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

    final PasswordField = TextFormField(
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

    return loading
        ? Loading()
        : Scaffold(
            backgroundColor: Colors.yellow[10],
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
              padding: EdgeInsets.symmetric(vertical: 40.0, horizontal: 50.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    //SizedBox(height: 10.0),
                    SizedBox(
                      height: 25.0,
                      child: Text(
                        'Sign in here!',
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.red,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(height: 10.0),
                    EmailField,
                    SizedBox(height: 20.0),
                    PasswordField,
                    SizedBox(height: 40.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        SizedBox(
                            width: 120,
                            child: RaisedButton(
                              onPressed: () => widget.toggleView(),
                              child: Text("Register",
                                  style: TextStyle(fontSize: 20)),
                              color: Colors.red,
                              textColor: Colors.white,
                            )),
                        SizedBox(
                            width: 120,
                            child: RaisedButton(
                              onPressed: () async {
                                if (_formKey.currentState.validate()) {
                                  setState(() => loading = true);
                                  dynamic result =
                                      await _auth.signInWithEmailAndPassword(
                                          email, password);
                                  if (result == null) {
                                    setState(() {
                                      loading = false;
                                      error =
                                          'Could not sign in with those credentials';
                                    });
                                  }
                                }
                              },
                              child: Text("Log In",
                                  style: TextStyle(fontSize: 20)),
                              color: Colors.orange,
                              textColor: Colors.white,
                            )),
                      ],
                    ),
                    SizedBox(height: 12.0),
                    Text(
                      error,
                      style: TextStyle(color: Colors.red, fontSize: 14.0),
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
