import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:youresta/models/dish.dart';
import 'package:youresta/models/review.dart';
import 'package:youresta/screens/home/insert_dish.dart';
import 'package:youresta/screens/home/update_dish.dart';
import 'package:youresta/screens/reviews_screen.dart';
import 'package:youresta/services/auth.dart';

import '../dish_detail_screen.dart';

class HomeCustomer extends StatefulWidget {
  final FirebaseUser user;

  HomeCustomer({this.user});

  @override
  HomeCustomerState createState() {
    return HomeCustomerState();
  }
}

class HomeCustomerState extends State<HomeCustomer> {
  final AuthService _auth = AuthService();
  final db = Firestore.instance;
  final _formKey = GlobalKey<FormState>();
  String name;
  int randomNumber = -1;

  Card buildItem(DocumentSnapshot doc) {
    return Card(
        margin: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: CircleAvatar(
                    radius: 25.0,
                    backgroundColor: Colors.brown[100],
                    backgroundImage: AssetImage('assets/coffee_icon.png'),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'name: ${doc.data['name']}',
                      style: TextStyle(fontSize: 24),
                    ),
                    Text(
                      'desc: ${doc.data['description']}',
                      style: TextStyle(fontSize: 20),
                    ),
                    Text(
                      'cost: ${doc.data['price']}',
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(height: 6),
                  ],
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                FlatButton(
                  onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DishDetailScreen(
                            dish: new Dish(
                              allergens: doc.data['allergens'],
                              description: doc.data['description'],
                              ingredients: doc.data['ingredients'],
                              name: doc.data['name'],
                              uid: doc.data['uid'],
                              owner: doc.data['owner'],
                              price: doc.data['price'],
                            ),
                          ))),
                  child: Text('Detail', style: TextStyle(color: Colors.orange)),
                  //color: Colors.blueGrey,
                ),
                FlatButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ReviewScreen(
                                dish: new Dish(
                                    allergens: doc.data['allergens'],
                                    description: doc.data['description'],
                                    ingredients: doc.data['ingredients'],
                                    name: doc.data['name'],
                                    uid: doc.data['uid'],
                                    owner: doc.data['owner'],
                                    price: doc.data['price'],
                                    reviews: doc.data['reviews']
                                        .map<Review>((document) {
                                      return new Review(
                                          stars: document['stars'],
                                          who: document['who'],
                                          text: document['text']);
                                    }).toList()))));
                  },
                  child:
                      Text('Reviews', style: TextStyle(color: Colors.orange)),
                  //color: Colors.green,
                ),
                SizedBox(width: 8),
              ],
            )
          ],
        ));
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
        backgroundColor: Colors.orange[100],
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
        body: StreamBuilder<QuerySnapshot>(
          stream: db.collection('dishes').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView(
                  padding: EdgeInsets.all(8),
                  children: snapshot.data.documents
                      .map((doc) => buildItem(doc))
                      .toList());
            } else {
              return SizedBox();
            }
          },
        ));
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
