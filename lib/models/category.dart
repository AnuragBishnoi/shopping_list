import 'package:flutter/material.dart';

enum Categories {
  vegetables,
  fruit,
  dairy,
  meat,
  carbs,
  sweets,
  spices,
  convenience,
  hygiene,
  other,
}

class Category {
  final String type;
  final Color? colour;
  const Category(this.type, this.colour);
}
