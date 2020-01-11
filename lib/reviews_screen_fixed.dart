import 'package:flutter/material.dart';
import 'package:youresta/model/review.dart';

class ReviewScreenFixed extends StatelessWidget {
  final List<Review> reviews;

  ReviewScreenFixed({this.reviews});

  @override
  Widget build(BuildContext context) {
    Row buildDisplayRow(Review review) {
      IconTheme star = IconTheme(
        data: IconThemeData(
          color: Colors.orange,
          size: 25,
        ),
        child: new Icon(Icons.star),
      );

      List<Widget> list = new List();

      int i = 0;

      for (; i < review.stars; i++) {
        list.add(star);
      }

      return Row(children: list);
    }

    Card buildItem(Review review) {
      return Card(
        margin: EdgeInsets.all(10.0),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              buildDisplayRow(review),
              Row(
                children: <Widget>[
                  Text(
                    'desc: ${review.who}',
                    style: TextStyle(fontSize: 20),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  Text(
                    'cost: ${review.text}€',
                    style: TextStyle(fontSize: 20),
                  ),
                ],
              ),
              SizedBox(height: 6),
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
        body: ListView(
          children: <Widget>[
            Column(
                //padding: EdgeInsets.all(8),
                children: reviews.map((doc) => buildItem(doc)).toList()),
          ],
        ));
  }
}
