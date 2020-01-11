import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';

class Review {
  int stars;
  String text;
  String who;
  Timestamp when;

  Review({Map document}) {
    if (document != null) {
      stars = document['stars'];
      who = document['who'];
      text = document['text'];
      when = document['when'];
    } else {
      stars = 0;
      text = '';
      who = '';
      when = Timestamp.now();
    }
  }
}
