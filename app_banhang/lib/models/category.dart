import 'package:flutter/material.dart';

class Category {
  String _categoryName;
  Image _image;
  //constructor
  Category(this._categoryName, this._image);

  get categoryName => this._categoryName;

  set categoryName(final value) => this._categoryName = value;

  get image => this._image;

  set image(value) => this._image = value;
}
