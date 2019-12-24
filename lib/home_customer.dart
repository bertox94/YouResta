import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:share/share.dart';
import 'package:youresta/model/custom_user.dart';
import 'package:youresta/model/dish.dart';
import 'package:youresta/model/review.dart';
import 'package:youresta/insert_dish.dart';
import 'package:youresta/update_dish.dart';
import 'package:youresta/reviews_screen_fixed.dart';
import 'package:youresta/auth_service.dart';

import 'dish_detail_screen.dart';
import 'reviews_screen_editable.dart';

class HomeCustomer extends StatefulWidget {
  final CustomUser customUser;

  HomeCustomer({this.customUser});

  @override
  HomeCustomerState createState() {
    return HomeCustomerState();
  }
}

class HomeCustomerState extends State<HomeCustomer> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  String name;
  int randomNumber = -1;

  dynamic buildAdditional1(DocumentSnapshot doc, var deviceData) {
    if (deviceData.orientation == Orientation.landscape) {
      return Text(
        'additional1: ${doc.data['allergenes']}',
        style: TextStyle(fontSize: 20),
      );
    } else {
      return SizedBox(
        height: 0,
        width: 0,
      );
    }
  }

  dynamic buildAdditional2(DocumentSnapshot doc, var deviceData) {
    if (deviceData.orientation == Orientation.landscape) {
      return Text(
        'additional2: add2',
        style: TextStyle(fontSize: 20),
      );
    } else {
      return SizedBox(
        height: 0,
        width: 0,
      );
    }
  }

  Card buildItem(DocumentSnapshot doc, var deviceData) {
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
                    backgroundImage: AssetImage(doc['picture']),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width * 0.65,
                        child: Text(
                          'name: ${doc.data['name']}',
                          maxLines: (MediaQuery.of(context).orientation ==
                                  Orientation.portrait
                              ? 1
                              : null),
                          softWrap: (MediaQuery.of(context).orientation ==
                                  Orientation.portrait
                              ? false
                              : true),
                          overflow: (MediaQuery.of(context).orientation ==
                                  Orientation.portrait
                              ? TextOverflow.fade
                              : null),
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.65,
                        child: Text(
                          'desc: ${doc.data['description']}',
                          maxLines: (MediaQuery.of(context).orientation ==
                                  Orientation.portrait
                              ? 1
                              : null),
                          softWrap: (MediaQuery.of(context).orientation ==
                                  Orientation.portrait
                              ? false
                              : true),
                          overflow: (MediaQuery.of(context).orientation ==
                                  Orientation.portrait
                              ? TextOverflow.fade
                              : null),
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.65,
                        child: Text(
                          'cost: ${doc.data['price']}€',
                          maxLines: (MediaQuery.of(context).orientation ==
                                  Orientation.portrait
                              ? 1
                              : null),
                          softWrap: (MediaQuery.of(context).orientation ==
                                  Orientation.portrait
                              ? false
                              : true),
                          overflow: (MediaQuery.of(context).orientation ==
                                  Orientation.portrait
                              ? TextOverflow.fade
                              : null),
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                      buildAdditional1(doc, deviceData),
                      buildAdditional2(doc, deviceData),
                      SizedBox(height: 6),
                    ],
                  ),
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
                            builder: (context) => ReviewScreenEditable(
                                user: widget.customUser,
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
                FlatButton(
                  onPressed: () {
                    RenderBox renderBox = context.findRenderObject();
                    String text =
                        'I found this amazing dish: ${doc.data[name]} at Restaurant: ${doc['owner']}. Check this out on YouResta!';

                    Share.share(text,
                        subject: '${doc.data[name]}',
                        sharePositionOrigin:
                            renderBox.localToGlobal(Offset.zero) &
                                renderBox.size);
                  },
                  child: new Icon(
                    Icons.share,
                    color: Colors.orange,
                    //size: 30,
                  ),
                  //color: Colors.blueGrey,
                ),
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
    var deviceData = MediaQuery.of(context);

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
              label: Text('Log Out'),
              onPressed: () async {
                await _auth.signOut();
              },
              icon: Icon(Icons.exit_to_app),
            ),
          ],
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: Firestore.instance.collection('dishes').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView(
                  padding: EdgeInsets.all(8),
                  children: snapshot.data.documents
                      .map((doc) => buildItem(doc, deviceData))
                      .toList());
            } else {
              return SizedBox();
            }
          },
        ));
  }
}
