import 'package:youresta/model/review.dart';

class Dish {
  String name;
  int price;
  String allergens;
  String uid;
  String description;
  String ingredients;
  String owner;
  String picture;
  List<Review> reviews;

  Dish({
    this.uid,
    this.allergens,
    this.price,
    this.description,
    this.name,
    this.ingredients,
    this.owner,
    this.reviews,
    this.picture,
  });
}
