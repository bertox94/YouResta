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
  final DocumentSnapshot oldDish;

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

  @override
  Widget build(BuildContext context) {
    dish.name = widget.oldDish['name'];
    dish.description = widget.oldDish['description'];
    dish.price = widget.oldDish['price'];
    dish.allergens = widget.oldDish['allergens'];
    dish.ingredients = widget.oldDish['ingredients'];

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
                    dish.name,
                    (val) {
                      dish.name = val;
                    },
                  ),
                  Commons.buildDishPriceField(
                    dish.price.toString(),
                    (val) {
                      dish.price = int.parse(val);
                    },
                  ),
                  Commons.buildIngredientsField(dish.ingredients, (val) {
                    dish.ingredients = val;
                  }),
                  Commons.buildDescriptionField(dish.description, (val) {
                    dish.description = val;
                  }),
                  Commons.buildAllergensField(dish.allergens, (val) {
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
          .document(widget.oldDish['uid'])
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
