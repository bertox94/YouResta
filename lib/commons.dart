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

  static TextFormField buildDishNameField(String initial, Function onChanged) {
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

  static TextFormField buildAllergensField(String initial, Function onChanged) {
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

  static TextFormField buildDescriptionField(
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

  static TextFormField buildIngredientsField(
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

  static TextFormField buildDishPriceField(String initial, Function onChanged) {
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
}
