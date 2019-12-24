import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:youresta/model/custom_user.dart';
import 'package:youresta/model/dish.dart';
import 'package:youresta/auth_service.dart';
import 'package:youresta/loading.dart';

import 'commons.dart';

class UpdateDish extends StatefulWidget {
  final Dish oldDish;

  UpdateDish({this.oldDish});

  @override
  UpdateDishState createState() {
    return UpdateDishState();
  }
}

class UpdateDishState extends State<UpdateDish> {
  String id;
  final formKey = GlobalKey<FormState>();
  Dish dish = new Dish();
  bool loaded = false;

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
    if (!loaded) {
      dish.name = widget.oldDish.name;
      dish.description = widget.oldDish.description;
      dish.price = widget.oldDish.price;
      dish.allergens = widget.oldDish.allergens;
      dish.ingredients = widget.oldDish.ingredients;
      dish.owner = widget.oldDish.owner;
      dish.uid = widget.oldDish.uid;
      loaded = true;
    }

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
                    widget.oldDish.name,
                    (val) {
                      dish.name = val;
                    },
                  ),
                  Commons.buildDishPriceField(
                    widget.oldDish.price.toString(),
                    (val) {
                      dish.price = int.parse(val);
                    },
                  ),
                  Commons.buildIngredientsField(widget.oldDish.ingredients,
                      (val) {
                    dish.ingredients = val;
                  }),
                  Commons.buildDescriptionField(widget.oldDish.description,
                      (val) {
                    dish.description = val;
                  }),
                  Commons.buildAllergensField(widget.oldDish.allergens, (val) {
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
                              updateData();
                              Navigator.pop(context);
                            },
                            child: new Icon(Icons.save),
                          ),
                        ],
                      ))
                ])));
  }

  void updateData() async {
    if (formKey.currentState.validate()) {
      formKey.currentState.save();

      await Firestore.instance
          .collection('dishes')
          .document(widget.oldDish.uid)
          .updateData({
        'allergens': dish.allergens,
        'price': dish.price,
        'description': dish.description,
        'name': dish.name,
        'ingredients': dish.ingredients,
      });
    }
  }
}
