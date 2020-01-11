import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:youresta/model/dish.dart';
import 'package:youresta/reviews_screen_editable.dart';

import 'commons.dart';
import 'model/review.dart';

class DishDetailScreen extends StatelessWidget {
  final DocumentSnapshot dish;

  DishDetailScreen({this.dish});

  @override
  Widget build(BuildContext context) {
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
                            context, doc, '', 'name', '', 26, true, true),
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
                            '€', 20, true, true),
                        Commons.buildTextField(context, doc, 'Allergens: ',
                            'allergens', '', 20, true, true),
                        Commons.buildTextField(context, doc, 'Description: ',
                            'description', '', 20, false, true),
                        Commons.buildTextField(context, doc, 'Ingredients: ',
                            'ingredients', '', 20, false, true),
                        Commons.buildTextField(
                            context, doc, 'Owner', 'owner', '', 20, false, false),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ));
    }

    return Scaffold(
        backgroundColor: Colors.orange[100],
        appBar: AppBar(backgroundColor: Colors.deepOrange),
        body: ListView(
            padding: EdgeInsets.all(8), children: {buildItem(dish)}.toList()));
  }
}
