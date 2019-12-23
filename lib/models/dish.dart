import 'package:youresta/models/review.dart';

class Dish {
  String allergens;
  String uid;
  int price;
  String description;
  String name;
  String ingredients;
  String owner;
  //String type; carne o pesce, sulla abse di questo sceglo l'avatar
  List<Review> reviews;

  //final String picture;

  Dish({
    this.uid,
    this.allergens,
    this.price,
    this.description,
    this.name,
    this.ingredients,
    this.owner,
    this.reviews,
    //this.picture,
  });
}
