import 'package:flutter/material.dart';
import 'package:youresta/model/dish.dart';

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
                'name: ',
                style: TextStyle(fontSize: 24),
              ),
              Text(
                'desc: ',
                style: TextStyle(fontSize: 20),
              ),
              Text(
                'cost: ',
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(height: 6),
            ],
          ),
        ),
      );
    }

    return Scaffold(
        backgroundColor: Colors.orange[100],
        appBar: AppBar(backgroundColor: Colors.deepOrange),
        body: ListView(
            padding: EdgeInsets.all(8),
            children: {buildItem(dish)}.toList()));
  }
}
