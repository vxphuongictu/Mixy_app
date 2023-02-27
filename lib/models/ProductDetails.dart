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
    return ProductDetails(
      title: removeHtmlTags(json['title']),
      name: removeHtmlTags(json['name']),
      content: removeHtmlTags(json['content']),
      price: json['price'],
      galleryImages: json['galleryImages']['nodes']
    );
  }
}