import 'package:flutter/material.dart';
import 'package:youresta/commons.dart';
import 'package:youresta/model/review.dart';

class ReviewScreenFixed extends StatelessWidget {
  final List<Review> reviews;

  ReviewScreenFixed({this.reviews});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.orange[100],
        appBar: AppBar(
          backgroundColor: Colors.deepOrange,
        ),
        body: ListView(
          children: <Widget>[
            Column(
                //padding: EdgeInsets.all(8),
                children:
                    reviews.map((doc) => Commons.buildReview(doc)).toList()),
          ],
        ));
  }
}
