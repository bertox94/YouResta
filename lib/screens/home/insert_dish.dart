import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:youresta/models/custom_user.dart';
import 'package:youresta/models/dish.dart';
import 'package:youresta/services/auth.dart';

class InsertDish extends StatefulWidget {
  final FirebaseUser user;

  InsertDish({this.user});

  @override
  InsertDishState createState() {
    return InsertDishState();
  }
}

class InsertDishState extends State<InsertDish> {
  String id;
  final db = Firestore.instance;
  final _formKey = GlobalKey<FormState>();
  Dish dish = new Dish();

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
    return StreamBuilder(
        stream: Firestore.instance.collection('custom_users').snapshots(),
        builder: (context, snapshot) {
          List customUsers =
              snapshot.data.documents.map((doc) => buildItem(doc)).toList();

          CustomUser selected;

          for (int i = 0; i < customUsers.length; i++) {
            if (customUsers.elementAt(i).uid == widget.user.uid)
              selected = customUsers.elementAt(i);
          }

          return Scaffold(
              backgroundColor: Colors.orange[200],
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
                  key: _formKey,
                  child: ListView(
                      padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                      children: <Widget>[
                        SizedBox(height: 10),
                        build1(),
                        build2(),
                        build3(),
                        build4(),
                        Container(
                            padding: EdgeInsets.fromLTRB(0, 20, 10, 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                FloatingActionButton(
                                  backgroundColor: Colors.deepOrange,
                                  elevation: 5,
                                  onPressed: () {
                                    createData(selected);
                                  },
                                  child: new Icon(Icons.add),
                                ),
                              ],
                            ))
                      ])));
        });
  }

  TextFormField build1() {
    return TextFormField(
        keyboardType: TextInputType.multiline,
        maxLines: null,
        validator: (val) => val.isEmpty ? 'Enter an email' : null,
        onChanged: (val) {
          setState(() => dish.allergens = val);
        },
        obscureText: false,
        style: TextStyle(
            fontFamily: 'Montserrat', fontSize: 20.0, color: Colors.white),
        decoration: InputDecoration(
          icon: new Icon(Icons.invert_colors),
          //contentPadding: EdgeInsets.fromLTRB(10.0, 15.0, 20.0, 15.0),
          hintText: 'Allergens',
          hintStyle: TextStyle(fontSize: 20.0, color: Colors.grey),
          //border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
        ));
  }

  TextFormField build2() {
    return TextFormField(
        keyboardType: TextInputType.number,
        inputFormatters: <TextInputFormatter>[
          WhitelistingTextInputFormatter.digitsOnly
        ],
        maxLines: null,
        validator: (val) => val.isEmpty ? 'Enter an email' : null,
        onChanged: (val) {
          setState(() => dish.price = int.parse(val));
        },
        obscureText: false,
        style: TextStyle(
            fontFamily: 'Montserrat', fontSize: 20.0, color: Colors.white),
        decoration: InputDecoration(
          icon: new Icon(Icons.euro_symbol),
          //contentPadding: EdgeInsets.fromLTRB(10.0, 15.0, 20.0, 15.0),
          hintText: 'Price',
          hintStyle: TextStyle(fontSize: 20.0, color: Colors.grey),
          //border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
        ));
  }

  TextFormField build3() {
    return TextFormField(
        keyboardType: TextInputType.multiline,
        maxLines: null,
        validator: (val) => val.isEmpty ? 'Enter an email' : null,
        onChanged: (val) {
          //setState(() => email = val);
        },
        obscureText: false,
        style: TextStyle(
            fontFamily: 'Montserrat', fontSize: 20.0, color: Colors.white),
        decoration: InputDecoration(
          icon: new Icon(Icons.description),
          //contentPadding: EdgeInsets.fromLTRB(10.0, 15.0, 20.0, 15.0),
          hintText: 'Description',
          hintStyle: TextStyle(fontSize: 20.0, color: Colors.grey),
          //border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
        ));
  }

  TextFormField build4() {
    return TextFormField(
        keyboardType: TextInputType.multiline,
        maxLines: null,
        validator: (val) => val.isEmpty ? 'Enter an email' : null,
        onChanged: (val) {
          //setState(() => email = val);
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
          //setState(() => email = val);
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

  TextFormField build6() {
    return TextFormField(
        keyboardType: TextInputType.multiline,
        maxLines: null,
        validator: (val) => val.isEmpty ? 'Enter an email' : null,
        onChanged: (val) {
          //setState(() => email = val);
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

  void createData(CustomUser selected) async {
    if (_formKey.currentState.validate()) {
      //_formKey.currentState.save();
      DocumentReference ref = await db.collection('dishes').add({
        'allergens': dish.allergens,
        'price': dish.price,
        'description': dish.description,
        'name': dish.name,
        'ingredients': dish.ingredients,
        'owner': selected.name,
      });
      //setState(() => id = ref.documentID);
      //print(ref.documentID);
    }
  }
}
