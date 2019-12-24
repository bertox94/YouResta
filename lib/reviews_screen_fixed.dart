import 'package:flutter/material.dart';
import 'package:youresta/model/review.dart';

class FixedReviewScreen extends StatelessWidget {
  final List<Review> reviews;

  FixedReviewScreen({this.reviews});

  @override
  Widget build(BuildContext context) {
    Card buildItem(Review review) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'name: ${review.stars}',
                style: TextStyle(fontSize: 24),
              ),
              Text(
                'desc: ${review.who}',
                style: TextStyle(fontSize: 20),
              ),
              Text(
                'cost: ${review.text}€',
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
        appBar: AppBar(backgroundColor: Colors.deepOrange,),
        body: ListView(
            padding: EdgeInsets.all(8),
            children: reviews.map((doc) => buildItem(doc)).toList()));
  }
}

