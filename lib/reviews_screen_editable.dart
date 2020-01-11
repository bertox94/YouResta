import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:youresta/model/dish.dart';
import 'package:youresta/model/review.dart';

import 'commons.dart';

class ReviewScreenEditable extends StatefulWidget {
  final Dish dish;
  final String user;

  ReviewScreenEditable({this.dish, this.user});

  @override
  _ReviewScreenEditableState createState() => _ReviewScreenEditableState();
}

class _ReviewScreenEditableState extends State<ReviewScreenEditable> {
  Review review = new Review();
  final formKey = GlobalKey<FormState>();
  String error = '';

  @override
  Widget build(BuildContext context) {
    Row build4() {
      List<Widget> list = new List();

      list.add(IconButton(
        icon: (review.stars < 1
            ? new Icon(Icons.star_border)
            : new Icon(Icons.star)),
        color: (review.stars < 1 ? Colors.blue : Colors.orange),
        iconSize: 30,
        onPressed: () {
          setState(() {
            review.stars = 1;
          });
        },
      ));

      list.add(IconButton(
        icon: (review.stars < 2
            ? new Icon(Icons.star_border)
            : new Icon(Icons.star)),
        color: (review.stars < 2 ? Colors.blue : Colors.orange),
        iconSize: 30,
        onPressed: () {
          setState(() {
            review.stars = 2;
          });
        },
      ));

      list.add(IconButton(
        icon: (review.stars < 3
            ? new Icon(Icons.star_border)
            : new Icon(Icons.star)),
        color: (review.stars < 3 ? Colors.blue : Colors.orange),
        iconSize: 30,
        onPressed: () {
          setState(() {
            review.stars = 3;
          });
        },
      ));

      list.add(IconButton(
        icon: (review.stars < 4
            ? new Icon(Icons.star_border)
            : new Icon(Icons.star)),
        color: (review.stars < 4 ? Colors.blue : Colors.orange),
        iconSize: 30,
        onPressed: () {
          setState(() {
            review.stars = 4;
          });
        },
      ));

      list.add(IconButton(
        icon: (review.stars < 5
            ? new Icon(Icons.star_border)
            : new Icon(Icons.star)),
        color: (review.stars < 5 ? Colors.blue : Colors.orange),
        iconSize: 30,
        onPressed: () {
          setState(() {
            review.stars = 5;
          });
        },
      ));

      return Row(mainAxisAlignment: MainAxisAlignment.center, children: list);
    }

    TextFormField build5() {
      return TextFormField(
          keyboardType: TextInputType.multiline,
          maxLines: null,
          validator: (val) => val.isEmpty ? 'Enter a description' : null,
          onChanged: (val) {
            setState(() => review.text = val);
          },
          obscureText: false,
          style: TextStyle(
              fontFamily: 'Montserrat', fontSize: 20.0, color: Colors.white),
          decoration: InputDecoration(
            icon: new Icon(Icons.text_fields),
            //contentPadding: EdgeInsets.fromLTRB(10.0, 15.0, 20.0, 15.0),
            hintText: 'Text',
            hintStyle: TextStyle(fontSize: 20.0, color: Colors.grey),
            //border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
          ));
    }

    void saveReview() async {
      review.who = widget.user;
      review.when = Timestamp.now();

      int selected;
      for (int i = 0; i < widget.dish.reviews.length; i++) {
        if (widget.dish.reviews.elementAt(i).who == widget.user) {
          selected = i;
        }
      }

      if (selected != null) {
        widget.dish.reviews.removeAt(selected);
      }

      widget.dish.reviews.add(review);

      List<Map<String, dynamic>> list = new List();
      for (int i = 0; i < widget.dish.reviews.length; i++) {
        Map<String, dynamic> map = new HashMap();
        map['who'] = widget.dish.reviews.elementAt(i).who;
        map['stars'] = widget.dish.reviews.elementAt(i).stars;
        map['text'] = widget.dish.reviews.elementAt(i).text;
        map['when'] = widget.dish.reviews.elementAt(i).when;
        list.add(map);
      }

      await Firestore.instance
          .collection('dishes')
          .document(widget.dish.uid)
          .updateData({
        'reviews': list,
      });
    }

    Form buildNewReview() {
      return Form(
          key: formKey,
          child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(children: <Widget>[
                build4(),
                build5(),
                SizedBox(
                  height: 10,
                ),
                Text(
                  error,
                  style: TextStyle(color: Colors.red, fontSize: 14.0),
                ),
                Container(
                  margin: EdgeInsets.all(8),
                  child: FlatButton(
                    onPressed: () {
                      bool f1 = false;
                      bool f2 = false;
                      if (formKey.currentState.validate()) {
                        formKey.currentState.save();
                        f1 = true;
                      }
                      if (review.stars != 0) {
                        f2 = true;
                      } else {
                        setState(() {
                          error = 'Must give at least 1 star.';
                        });
                      }
                      if (f1 && f2) {
                        saveReview();
                        Navigator.pop(context);
                      }
                    },
                    color: Colors.orange,
                    child: Text('Save', style: TextStyle(color: Colors.white)),
                  ),
                )
              ])));
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
                children: widget.dish.reviews
                    .map((doc) => Commons.buildReview(doc))
                    .toList()),
            buildNewReview(),
          ],
        ));
  }
}
