import 'package:youresta/model/review.dart';

class Dish {
  String allergens;
  String uid;
  int price;
  String description;
  String name;
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
