import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:youresta/models/custom_user.dart';
import 'package:youresta/models/dish.dart';
import 'package:youresta/models/review.dart';
import 'package:youresta/screens/home/insert_dish.dart';
import 'package:youresta/screens/home/update_dish.dart';
import 'package:youresta/services/auth.dart';

class ReviewScreenEditable extends StatefulWidget {
  final Dish dish;
  final CustomUser user;

  ReviewScreenEditable({this.dish, this.user});

  @override
  _ReviewScreenEditableState createState() => _ReviewScreenEditableState();
}

class _ReviewScreenEditableState extends State<ReviewScreenEditable> {
  Review review = new Review();

  @override
  Widget build(BuildContext context) {
    TextFormField build4() {
      return TextFormField(
          keyboardType: TextInputType.multiline,
          maxLines: null,
          validator: (val) => val.isEmpty ? 'Enter an email' : null,
          onChanged: (val) {
            setState(() => review.stars = int.parse(val));
          },
          obscureText: false,
          style: TextStyle(
              fontFamily: 'Montserrat', fontSize: 20.0, color: Colors.white),
          decoration: InputDecoration(
            icon: new Icon(Icons.edit),
            //contentPadding: EdgeInsets.fromLTRB(10.0, 15.0, 20.0, 15.0),
            hintText: 'Dish name',
            hintStyle: TextStyle(fontSize: 20.0, color: Colors.grey),
            //border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
          ));
    }

    TextFormField build5() {
      return TextFormField(
          keyboardType: TextInputType.multiline,
          maxLines: null,
          validator: (val) => val.isEmpty ? 'Enter an email' : null,
          onChanged: (val) {
            setState(() => review.text = val);
          },
          obscureText: false,
          style: TextStyle(
              fontFamily: 'Montserrat', fontSize: 20.0, color: Colors.white),
          decoration: InputDecoration(
            icon: new Icon(Icons.mail),
            //contentPadding: EdgeInsets.fromLTRB(10.0, 15.0, 20.0, 15.0),
            hintText: 'Email',
            hintStyle: TextStyle(fontSize: 20.0, color: Colors.grey),
            //border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
          ));
    }

    void saveReview() async {
      /*  sync may be problematic
      
    DocumentSnapshot snapshot = await Firestore.instance
          .collection('dishes')
          .document(widget.dish.uid)
          .get();
    List<Review> reviews = snapshot.data['reviews'];
     */

      review.who = widget.user.name;
      widget.dish.reviews.add(review);

      await Firestore.instance
          .collection('dishes')
          .document(widget.dish.uid)
          .updateData({
        'reviews': widget.dish.reviews,
      });
    }

    Padding buildNewReview() {
      return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(children: <Widget>[
            build4(),
            build5(),
            FlatButton(
              onPressed: () {
                saveReview();
                Navigator.pop(context);
              },
              child: Text('Reviews', style: TextStyle(color: Colors.orange)),
            )
          ]));
    }

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
                'cost: ${review.text}',
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
        appBar: AppBar(
          backgroundColor: Colors.deepOrange,
        ),
        body: ListView(
          children: <Widget>[
            ListView(
                padding: EdgeInsets.all(8),
                children:
                    widget.dish.reviews.map((doc) => buildItem(doc)).toList()),
            buildNewReview(),
          ],
        ));
  }
}
