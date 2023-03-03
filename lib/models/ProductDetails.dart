/*
 * Model of product details
 * I import removeHtmlTags package because response from server is html
 */

import 'package:food_e/functions/products/removeHtmlTags.dart';

class ProductDetails {
  String ? name;
  String ? title;
  String ? content;
  String ? price;
  List ? galleryImages;

  ProductDetails({
    this.name,
    this.title,
    this.content,
    this.price,
    this.galleryImages
  });

  factory ProductDetails.fromJson(Map<String, dynamic> json) {
    String price = "0.0";
    try {
      price = json['price'].toString().replaceAll(' ', '').split('-')[1];
    } catch (e) {
      price = json['price'];
    };
    return ProductDetails(
      title: removeHtmlTags(json['title']),
      name: removeHtmlTags(json['name']),
      content: removeHtmlTags(json['content']),
      price: price,
      galleryImages: json['galleryImages']['nodes']
    );
  }
}