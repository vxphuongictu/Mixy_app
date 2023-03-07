/*
 * state manager of basket
 * it likely setState but you can using it in any screen
 */

import 'package:flutter/cupertino.dart';
import 'package:food_e/core/DatabaseManager.dart';
import 'package:food_e/models/Cart.dart';


class BasketProvider with ChangeNotifier
{
  List<Cart> _card = [];

  List<Cart> get cart => _card;

  Future<void> addCart(Cart item) async {
    await DatabaseManager().insertCart(cart: item);
    this.fetchCart(userID: item.userID);
  }

  Future<void> removeCart({required String id, required String userID}) async {
    await DatabaseManager().removeItemInCart(id: id, userID: userID);
    _card.removeWhere((cartItem) => cartItem.productID == id);
    notifyListeners();
  }

  Future<void> clearCart({required String userID}) async {
    await DatabaseManager().clearCart(userID: userID);
    _card = [];
    notifyListeners();
  }

  void fetchCart({required String userID}) {
    _card = [];
    DatabaseManager().fetchCart(userID: userID).then((value){
      value.forEach((element) {
        _card.add(
          Cart(
              productID: element['productID'],
              productName: element['productName'],
              productQuantity: element['productQuantity'],
              productThumbnails: element['productThumbnails'],
              productPrice: element['productPrice'],
              userID: element['userID']
          )
        );
      });
      notifyListeners();
    });
  }

  double totalPrice() {
    double _count = 0;
    _card.forEach((element) {
      String _price = element.productPrice.replaceAll("\$", "");
      try {
        _price = _price.split("-")[1].trim();
      } catch (e) {
        _price = _price.trim();
      }
      _count = _count + double.parse(_price);
    });
    return _count;
  }
}