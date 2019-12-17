import 'package:youresta/models/review.dart';

class Dish {
  final String allergenes;
  final int cost;
  final String description;
  final String name;
  final String owner;
  final List<Review> reviews;
  //final String picture;

  Dish({
    this.allergenes,
    this.cost,
    this.description,
    this.name,
    this.owner,
    this.reviews,
    //this.picture,
  });
}
