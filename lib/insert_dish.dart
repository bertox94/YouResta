import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:youresta/commons.dart';
import 'package:youresta/model/custom_user.dart';
import 'package:youresta/model/dish.dart';
import 'package:youresta/model/review.dart';
import 'package:youresta/auth_service.dart';
import 'package:youresta/loading.dart';

class InsertDish extends StatefulWidget {
  final CustomUser user;

  InsertDish({this.user});

  @override
  InsertDishState createState() {
    return InsertDishState();
  }
}

class InsertDishState extends State<InsertDish> {
  String id;
  final db = Firestore.instance;
  final formKey = GlobalKey<FormState>();
  Dish dish = new Dish();

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
      onSaved: (value) {},
    );
  }

  CustomUser buildItem(DocumentSnapshot doc) {
    return new CustomUser(
        uid: doc.data['uid'],
        name: doc.data['name'],
        isBusiness: doc.data['isBusiness']);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.orange[100],
        appBar: AppBar(
          title: Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
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
            key: formKey,
            child: ListView(
                padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                children: <Widget>[
                  SizedBox(height: 10),
                  Commons.buildDishNameField(
                    '',
                    (val) {
                      dish.name = val;
                    },
                  ),
                  Commons.buildDishPriceField(
                    '',
                    (val) {
                      dish.price = int.parse(val);
                    },
                  ),
                  Commons.buildIngredientsField('', (val) {
                    dish.ingredients = val;
                  }),
                  Commons.buildDescriptionField('', (val) {
                    dish.description = val;
                  }),
                  Commons.buildAllergensField('', (val) {
                    dish.allergens = val;
                  }),
                  Container(
                      padding: EdgeInsets.fromLTRB(0, 20, 10, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          FloatingActionButton(
                            backgroundColor: Colors.deepOrange,
                            elevation: 5,
                            onPressed: () {
                              createData();
                              Navigator.pop(context);
                            },
                            child: new Icon(Icons.add),
                          ),
                        ],
                      ))
                ])));
  }

  void createData() async {
    if (formKey.currentState.validate()) {
      formKey.currentState.save();
      DocumentReference ref = await db.collection('dishes').add({});

      await db.collection('dishes').document(ref.documentID).updateData({
        'uid': ref.documentID,
        'allergens': dish.allergens,
        'price': dish.price,
        'description': dish.description,
        'picture': 'chef-hat-${1 + Random().nextInt(9)}.jpg',
        'name': dish.name,
        'ingredients': dish.ingredients,
        'owner': widget.user.name,
        'reviews': new List<Review>(),
      });
    }
  }
}
