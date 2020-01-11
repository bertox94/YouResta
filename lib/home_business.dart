import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:youresta/auth_service.dart';
import 'package:youresta/insert_dish.dart';
import 'package:youresta/model/custom_user.dart';
import 'package:youresta/model/review.dart';
import 'package:youresta/reviews_screen_fixed.dart';
import 'package:youresta/update_dish.dart';

import 'commons.dart';

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
  String name;
  int randomNumber = -1;
  String title = '';

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
                          .map<Review>(
                              (document) => new Review(document: document))
                          .toList())),
                      SizedBox(
                        height: 6,
                      ),
                      Commons.buildTextField(context, doc, 'Price: ', 'price',
                          '€', 20, true, false),
                      Commons.buildTextField(context, doc, 'Allergens: ',
                          'allergens', '', 20, false, false),
                      Commons.buildTextField(context, doc, 'Ingredients: ',
                          'ingredients', '', 20, true, false),
                      SizedBox(
                        height: 6,
                      ),
                      Commons.buildTextField(context, doc, '', 'description',
                          '', 20, false, false),
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
                          builder: (context) => ReviewScreenFixed(
                              reviews: doc.data['reviews']
                                  .map<Review>((document) =>
                                      new Review(document: document))
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
                  child: Text(
                      (MediaQuery.of(context).orientation ==
                              Orientation.portrait
                          ? 'Update/Detail'
                          : 'Update'),
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
        body: Stack(
          children: <Widget>[
            StreamBuilder<QuerySnapshot>(
              stream: Firestore.instance
                  .collection('dishes')
                  .where('owner', isEqualTo: widget.user.name)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView(
                    children: <Widget>[
                      SizedBox(
                        height: 60,
                      ),
                      Column(
                          children: snapshot.data.documents
                              .where((x) => x['name']
                                  .toLowerCase()
                                  .contains(title.toLowerCase()))
                              .map((doc) => buildItem(doc))
                              .toList())
                    ],
                  );
                } else {
                  return SizedBox();
                }
              },
            ),
            Padding(
              padding: EdgeInsets.all(8),
              child: TextField(
                  onChanged: (val) {
                    setState(() {
                      title = val;
                    });
                  },
                  decoration: InputDecoration(
                    fillColor: Colors.blue[100],
                    filled: true,
                    icon: new Icon(Icons.text_fields),
                    //contentPadding: EdgeInsets.fromLTRB(10.0, 15.0, 20.0, 15.0),
                    hintText: 'Search you dish here...',
                    hintStyle: TextStyle(fontSize: 20.0, color: Colors.grey),
                    //border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
                  )),
            ),
          ],
        ));
  }

  void deleteData(DocumentSnapshot doc) async {
    await Firestore.instance
        .collection('dishes')
        .document(doc.documentID)
        .delete();
  }
}
