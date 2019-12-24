import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Commons {
  static TextFormField buildEmail(Function onChanged) {
    return TextFormField(
        validator: (val) {
          if (val.isEmpty) return 'Enter an email';
          if (!val.contains("@") || !val.contains("."))
            return 'Email badly formatted';
          return null;
        },
        onChanged: onChanged,
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

  static TextFormField buildPassword(Function onChanged) {
    return TextFormField(
      validator: (val) =>
          val.length < 6 ? 'Enter a password 6+ chars long' : null,
      onChanged: onChanged,
      obscureText: true,
      style: TextStyle(
          fontFamily: 'Montserrat', fontSize: 20.0, color: Colors.white),
      decoration: InputDecoration(
        icon: new Icon(Icons.lock),
        //contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        hintText: "Password",
        hintStyle: TextStyle(fontSize: 20.0, color: Colors.grey),
        //border:OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))
      ),
    );
  }

  static TextFormField buildDishNameFormField(
      String initial, Function onChanged) {
    return TextFormField(
        initialValue: initial,
        keyboardType: TextInputType.multiline,
        maxLines: null,
        validator: (val) => val.isEmpty ? 'Enter the dish name' : null,
        onChanged: onChanged,
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

  static TextFormField buildAllergensFormField(
      String initial, Function onChanged) {
    return TextFormField(
        initialValue: initial,
        keyboardType: TextInputType.multiline,
        maxLines: null,
        validator: (val) => val.isEmpty ? 'Enter the allergens' : null,
        onChanged: onChanged,
        obscureText: false,
        style: TextStyle(
            fontFamily: 'Montserrat', fontSize: 20.0, color: Colors.white),
        decoration: InputDecoration(
          icon: new Icon(Icons.invert_colors),
          hintText: 'Allergens',
          hintStyle: TextStyle(fontSize: 20.0, color: Colors.grey),
        ));
  }

  static TextFormField buildDescriptionFormField(
      String initial, Function onChanged) {
    return TextFormField(
        initialValue: initial,
        keyboardType: TextInputType.multiline,
        maxLines: null,
        validator: (val) => val.isEmpty ? 'Enter the description' : null,
        onChanged: onChanged,
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

  static TextFormField buildIngredientsFormField(
      String initial, Function onChanged) {
    return TextFormField(
        initialValue: initial,
        keyboardType: TextInputType.multiline,
        maxLines: null,
        validator: (val) => val.isEmpty ? 'Enter the ingredients' : null,
        onChanged: onChanged,
        obscureText: false,
        style: TextStyle(
            fontFamily: 'Montserrat', fontSize: 20.0, color: Colors.white),
        decoration: InputDecoration(
          icon: new Icon(Icons.list),
          //contentPadding: EdgeInsets.fromLTRB(10.0, 15.0, 20.0, 15.0),
          hintText: 'Ingredients',
          hintStyle: TextStyle(fontSize: 20.0, color: Colors.grey),
          //border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
        ));
  }

  static TextFormField buildDishPriceFormField(
      String initial, Function onChanged) {
    return TextFormField(
        initialValue: initial,
        keyboardType: TextInputType.number,
        inputFormatters: <TextInputFormatter>[
          WhitelistingTextInputFormatter.digitsOnly
        ],
        maxLines: null,
        validator: (val) => val.isEmpty ? 'Enter the dish price' : null,
        onChanged: onChanged,
        obscureText: false,
        style: TextStyle(
            fontFamily: 'Montserrat', fontSize: 20.0, color: Colors.white),
        decoration: InputDecoration(
          icon: new Icon(Icons.euro_symbol),
          hintText: 'Price',
          hintStyle: TextStyle(fontSize: 20.0, color: Colors.grey),
        ));
  }

  static CircleAvatar buildAvatar(DocumentSnapshot doc) {
    return CircleAvatar(
      radius: 25.0,
      backgroundImage: AssetImage('assets/${doc['picture']}'),
    );
  }

  static Container buildTextField(BuildContext context, DocumentSnapshot doc,
      String arg1, String arg2, String arg3, bool required) {
    if (required ||
        MediaQuery.of(context).orientation == Orientation.landscape) {
      return Container(
        width: MediaQuery.of(context).size.width * 0.65,
        child: Text(
          '$arg1: ${doc.data[arg2]}$arg3',
          maxLines: (MediaQuery.of(context).orientation == Orientation.portrait
              ? 1
              : null),
          softWrap: (MediaQuery.of(context).orientation == Orientation.portrait
              ? false
              : true),
          overflow: (MediaQuery.of(context).orientation == Orientation.portrait
              ? TextOverflow.fade
              : null),
          style: TextStyle(fontSize: 20),
        ),
      );
    } else
      return Container(
        width: 0,
        height: 0,
      );
  }
}
