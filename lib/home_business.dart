import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:youresta/model/custom_user.dart';
import 'package:youresta/model/dish.dart';
import 'package:youresta/model/review.dart';
import 'package:youresta/insert_dish.dart';
import 'package:youresta/update_dish.dart';
import 'package:youresta/reviews_screen_fixed.dart';
import 'package:youresta/auth_service.dart';

class HomeBusiness extends StatefulWidget {
  final CustomUser user;

  HomeBusiness({this.user});

  @override
  HomeBusinessState createState() {
    return HomeBusinessState();
  }
}

class HomeBusinessState extends State<HomeBusiness> {
  final AuthService _auth = AuthService();
  final formKey = GlobalKey<FormState>();
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
                    backgroundImage: AssetImage('assets/${doc['picture']}'),
                  ),
                ),
                Column(
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
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                FlatButton(
                  onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => FixedReviewScreen(
                              reviews: doc.data['reviews']
                                  .map<Review>((document) => new Review(
                                      stars: document['stars'],
                                      who: document['who'],
                                      text: document['text']))
                                  .toList()))),
                  child:
                      Text('Reviews', style: TextStyle(color: Colors.orange)),
                  //color: Colors.blueGrey,
                ),
                FlatButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => UpdateDish(oldDish: doc)));
                  },
                  child: Text('Update/Detail',
                      style: TextStyle(color: Colors.orange)),
                  //color: Colors.green,
                ),
                SizedBox(width: 8),
                FlatButton(
                  onPressed: () => deleteData(doc),
                  child: Text('Delete', style: TextStyle(color: Colors.red)),
                  //color: Colors.blueGrey,
                ),
              ],
            )
          ],
        ));
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
          stream: Firestore.instance
              .collection('dishes')
              .where('owner', isEqualTo: widget.user.name)
              .snapshots(),
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

  void deleteData(DocumentSnapshot doc) async {
    await Firestore.instance
        .collection('dishes')
        .document(doc.documentID)
        .delete();
  }
}
