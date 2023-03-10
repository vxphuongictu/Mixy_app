/*
 * Model of product details
 * I import removeHtmlTags package because response from server is html
 */

import 'package:food_e/functions/products/removeHtmlTags.dart';

class Products {
  String ? id;
  String ? name;
  String ? title;
  String ? description;
  String ? price;
  String ? thumbnail;
  List ? galleryImages;

  Products({
    this.id,
    this.name,
    this.title,
    this.description,
    this.price,
    this.thumbnail,
    this.galleryImages
  });

  factory Products.formJson(Map<String, dynamic> json) {
    String price = "0.0";
    try {
      price = json['price'].toString().replaceAll(' ', '').split('-')[1];
    } catch (e) {
      price = json['price'];
    };
    return Products(
      id: json['id'],
      name: (json['name'] != null) ? removeHtmlTags(json['name']) : null,
      title: (json['title'] != null) ? removeHtmlTags(json['title']) : null,
      description: (json['description'] != null) ? removeHtmlTags(json['description']) : null,
      price: price,
      thumbnail: (json['image'] != null) ? json['image']['sourceUrl'] : null
    );
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id,
      'name': name,
      'title': title,
      'description': description,
      'price': price,
      'thumbnail': thumbnail
    };
    return map;
  }

  Products.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    name = removeHtmlTags(map['name']);
    title = removeHtmlTags(map['title']);
    description = removeHtmlTags(map['description']);
    price = map['price'];
    thumbnail = map['thumbnail'];
  }
}