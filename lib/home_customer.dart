import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:share/share.dart';
import 'package:youresta/commons.dart';
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
                    child: Commons.buildAvatar(doc)),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Commons.buildTextField(
                          context, doc, '', 'name', '', 26, true, false),
                      Commons.buildDisplayStars(Commons.averageStars(doc
                          .data['reviews']
                          .map<Review>((document) => new Review(
                              stars: document['stars'],
                              who: document['who'],
                              text: document['text']))
                          .toList())),
                      SizedBox(
                        height: 6,
                      ),
                      Commons.buildTextField(context, doc, 'Price: ', 'price',
                          '€', 20, true, false),
                      Commons.buildTextField(context, doc, 'Allergens: ',
                          'allergens', '', 20, true, false),
                      Commons.buildTextField(context, doc, 'Description: ',
                          'description', '', 20, false, false),
                      Commons.buildTextField(context, doc, 'Ingredients: ',
                          'ingredients', '', 20, false, false),
                      Commons.buildTextField(
                          context, doc, 'Owner', 'owner', '', 20, false, false),
                    ],
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                (MediaQuery.of(context).orientation == Orientation.portrait
                    ? FlatButton(
                        onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    DishDetailScreen(dish: doc))),
                        child: Text('Detail',
                            style: TextStyle(color: Colors.orange)),
                        //color: Colors.blueGrey,
                      )
                    : SizedBox(
                        height: 0,
                        width: 0,
                      )),
                FlatButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ReviewScreenEditable(
                                user: widget.customUser.name,
                                dish: new Dish(
                                    uid: doc.data['uid'],
                                    reviews: doc.data['reviews']
                                        .map<Review>((document) => new Review(
                                            stars: document['stars'],
                                            who: document['who'],
                                            text: document['text']))
                                        .toList()))));
                  },
                  child:
                      Text('Reviews', style: TextStyle(color: Colors.orange)),
                  //color: Colors.green,
                ),
                FlatButton(
                  onPressed: () {
                    RenderBox renderBox = context.findRenderObject();
                    String text =
                        'I found this amazing dish: ${doc.data['name']} at Restaurant: ${doc['owner']}. Check this out on YouResta!';

                    Share.share(text,
                        subject: '${doc.data['name']}',
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
                      .map((doc) => buildItem(doc))
                      .toList());
            } else {
              return SizedBox();
            }
          },
        ));
  }
}
