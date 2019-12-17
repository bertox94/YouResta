import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:youresta/models/dish.dart';
import 'package:youresta/screens/home/insert_dish.dart';
import 'package:youresta/screens/home/update_dish.dart';
import 'package:youresta/services/auth.dart';

class HomeBusiness extends StatefulWidget {
  final FirebaseUser user;

  HomeBusiness({this.user});

  @override
  HomeBusinessState createState() {
    return HomeBusinessState();
  }
}

class HomeBusinessState extends State<HomeBusiness> {
  final AuthService _auth = AuthService();
  final db = Firestore.instance;
  final _formKey = GlobalKey<FormState>();
  String name;
  int randomNumber = -1;

  Card buildItem(DocumentSnapshot doc) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'name: ${doc.data['name']}',
              style: TextStyle(fontSize: 24),
            ),
            Text(
              'todo: ${doc.data['todo']}',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                FlatButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => UpdateDish(
                                user: widget.user,
                                oldDish: new Dish(
                                    allergens: doc.data['allergens'],
                                    description: doc.data['description'],
                                    ingredients: doc.data['ingredients'],
                                    name: doc.data['name'],
                                    owner: doc.data['owner'],
                                    price: doc.data['price'],
                                    reviews: doc.data['reviews']))));
                  },
                  child: Text('Update todo',
                      style: TextStyle(color: Colors.white)),
                  color: Colors.green,
                ),
                SizedBox(width: 8),
                FlatButton(
                  onPressed: () => deleteData(doc),
                  child: Text('Delete'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  TextFormField buildTextFormField() {
    return TextFormField(
      onChanged: (val) {
        setState(() => name = val);
      },
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
        actions: <Widget>[
          FlatButton.icon(
            label: Text('Add'),
            onPressed: () async {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => InsertDish(
                            user: widget.user,
                          )));
            },
            icon: Icon(Icons.restaurant_menu),
          ),
          FlatButton.icon(
            label: Text('Log Out'),
            onPressed: () async {
              await _auth.signOut();
            },
            icon: Icon(Icons.exit_to_app),
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.all(8),
        children: <Widget>[
          Form(
            key: _formKey,
            child: buildTextFormField(),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              RaisedButton(
                onPressed: createData,
                child: Text('Create', style: TextStyle(color: Colors.white)),
                color: Colors.green,
              ),
            ],
          ),
          StreamBuilder<QuerySnapshot>(
            stream: db.collection('dishes').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Column(
                    children: snapshot.data.documents
                        .map((doc) => buildItem(doc))
                        .toList());
              } else {
                return SizedBox();
              }
            },
          )
        ],
      ),
    );
  }

  void createData() async {
    if (_formKey.currentState.validate()) {
      DocumentReference ref = await db
          .collection('dishes')
          .add({'name': '$name 😎', 'todo': randomTodo()});
      print(ref.documentID);
    }
  }

  //how to get the element, however remind that you should use streams
  void readData() async {
    DocumentSnapshot snapshot =
        await db.collection('CRUD').document('id').get();
    print(snapshot.data['name']);
  }

  void updateData(DocumentSnapshot doc) async {
    await db
        .collection('CRUD')
        .document(doc.documentID)
        .updateData({'todo': 'please 🤫'});
  }

  void deleteData(DocumentSnapshot doc) async {
    await db.collection('dishes').document(doc.documentID).delete();
  }

  String randomTodo() {
    randomNumber++;
    randomNumber %= 4;
    String todo;
    switch (randomNumber) {
      case 0:
        todo = 'Like and subscribe 💩';
        break;
      case 1:
        todo = 'Twitter @robertbrunhage 🤣';
        break;
      case 2:
        todo = 'Patreon in the description 🤗';
        break;
      case 3:
        todo = 'Leave a comment 🤓';
        break;
    }
    return todo;
  }
}
