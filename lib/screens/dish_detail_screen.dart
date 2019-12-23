import 'package:flutter/material.dart';
import 'package:youresta/models/dish.dart';

class DishDetailScreen extends StatelessWidget {
  final Dish dish;

  DishDetailScreen({this.dish});

  @override
  Widget build(BuildContext context) {
    Card buildItem(Dish dish) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'name: ${dish.name}',
                style: TextStyle(fontSize: 24),
              ),
              Text(
                'desc: ${dish.owner}',
                style: TextStyle(fontSize: 20),
              ),
              Text(
                'cost: ${dish.ingredients}',
                style: TextStyle(fontSize: 20),
              ),
              Text(
                'cost: ${dish.allergens}',
                style: TextStyle(fontSize: 20),
              ),
              //SizedBox(height: 6),
            ],
          ),
        ),
      );
    }

    return Scaffold(
        backgroundColor: Colors.orange[100],
        appBar: AppBar(
          backgroundColor: Colors.deepOrange,
        ),
        body: Container(padding: EdgeInsets.all(0), child: buildItem(dish)));
  }
}

/*
        StreamBuilder<DocumentSnapshot>(
          stream: Firestore.instance
              .collection('dishes')
              .document(dish.uid)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView(
                  padding: EdgeInsets.all(8),
                  children: snapshot.data.data['reviews']
                      .map((doc) => buildItem(doc))
                      .toList());
            } else {
              return SizedBox();
            }
          },
        ));

             */
