/*
 * state manager of Liked (favourite)
 * it likely setState but you can using it in any screen
 */

import 'package:flutter/cupertino.dart';
import 'package:food_e/core/DatabaseManager.dart';
import 'package:food_e/models/Favourites.dart';


class LikedProvider with ChangeNotifier
{
  List<Favourites> _liked = [];
  List<Favourites> get liked => _liked;

  Future<void> like({required Favourites item}) async {
    await DatabaseManager().favourite(item: item);
    checkFavourite(id: item.idFavourite!, userID: item.userID!).then((value){
      if (value == false) {
        _liked.add(item);
      } else {
        _liked.removeWhere((element) => element.idFavourite == item.idFavourite);
      }
    });
    notifyListeners();
  }

  Future<void> removeLiked({required String id, required String userID}) async {
    await DatabaseManager().removeItemInFavourite(id: id, userID: userID);
    _liked.removeWhere((likedItem) => likedItem.idFavourite == id);
    notifyListeners();
  }

  Future<void> clearLiked({required String userID}) async {
    await DatabaseManager().clearFavourite(userID: userID);
    _liked = [];
    this.fetchLiked(userID: userID);
  }

  Future<void> fetchLiked({required String userID}) async {
    _liked = [];
    DatabaseManager().fetchFavouriteItem(userID: userID).then((value){
      value.forEach((element) {
        _liked.add(
          Favourites(
            idFavourite: element['idFavourite'],
            nameFavourite: element['nameFavourite'],
            priceFavourite: element['priceFavourite'],
            thumbnailFavourite: element['thumbnailFavourite'],
            userID: userID
          )
        );
      });
      notifyListeners();
    });
  }

  checkFavourite({required String id, required String userID}) async {
    bool _isFavourite = await DatabaseManager().checkFavourite(id: id, userID: userID);
    notifyListeners();
    return _isFavourite;
  }

  int countLiked() {
    int _count = 0;
    _liked.forEach((element) {
      _count ++;
    });
    return _count;
  }
}