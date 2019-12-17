import 'package:youresta/models/review.dart';

class Dish {
  String allergens;
  int price;
  String description;
  String name;
  String ingredients;
  String owner;
  List<Review> reviews;

  //final String picture;

  Dish({
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
