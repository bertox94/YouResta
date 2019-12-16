import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:youresta/services/auth.dart';

class InsertDish extends StatefulWidget {
  @override
  InsertDishState createState() {
    return InsertDishState();
  }
}

class InsertDishState extends State<InsertDish> {
  String id;
  final db = Firestore.instance;
  final _formKey = GlobalKey<FormState>();
  String name;
  int randomNumber = -1;

  TextFormField buildTextFormField() {
    return TextFormField(
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: 'name',
        fillColor: Colors.grey[300],
        filled: true,
      ),
      validator: (value) {
        if (value.isEmpty) {
          return 'Please enter some text';
        }
        return null;
      },
      onSaved: (value) => name = value,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.orange[200],
        appBar: AppBar(
          title: Container(
            child: Row(
              children: <Widget>[
                Image.asset(
                  'assets/logo.png',
                  scale: 40,
                ),
              ],
            ),
          ),
          backgroundColor: Colors.deepOrange,
          elevation: 0.0,
          actions: <Widget>[],
        ),
        body: Form(
            key: _formKey,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                RaisedButton(
                  onPressed: createData,
                  child: Text('Create', style: TextStyle(color: Colors.white)),
                  color: Colors.green,
                ),
              ],
            )));
  }

  void createData() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      DocumentReference ref =
          await db.collection('CRUD').add({'name': '$name 😎', 'todo': 1});
      setState(() => id = ref.documentID);
      print(ref.documentID);
    }
  }
}
