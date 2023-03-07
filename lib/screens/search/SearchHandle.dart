/*
 - This widget will show when clients tap to input form and handle data from endpoint
 */

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:food_e/core/DatabaseManager.dart';
import 'package:food_e/models/Cart.dart';
import 'package:food_e/models/Products.dart';
import 'package:food_e/screens/product/ProductDetail.dart';
import 'package:food_e/widgets/ItemBox.dart';
import 'package:food_e/widgets/Loading.dart';
import 'package:food_e/requests/searchProducts.dart';
import 'package:food_e/core/SharedPreferencesClass.dart';


class SearchHandle extends StatefulWidget
{

  String searchText;

  SearchHandle({
    this.searchText = "",
  });

  @override
  State<SearchHandle> createState() {
    return _SearchHandle();
  }
}

class _SearchHandle extends State<SearchHandle>
{

  /// space between
  final double spaceBetweenFromTitleToContent = 40.0;

  /// has data
  List<Products> ? _response;

  /// define userID
  String _userID = "";

  /// define SharedPreferencesClass
  SharedPreferencesClass _shared = SharedPreferencesClass();

  @override
  void initState() {
    super.initState();
    _shared.get_user_info().then((value) {
      setState(() {
        this._userID = value.userID;
      });
    });

    searchProduct(name: this.widget.searchText).then((value) {
      setState(() {
        this._response = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return _focusWidget();
  }


  Widget _focusWidget()
  {
    if (this._response == null) {
      return SizedBox(
        height: MediaQuery.of(context).size.height * .7,
        child: Loading(),
      );
    } else if (this._response!.isEmpty) {
      return SizedBox(
        height: MediaQuery.of(context).size.height * .7,
        child: Image.asset('assets/images/search-not-found.png'),
      );
    } else {
      final _heightScreen = MediaQuery.of(context).size.height;
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(10.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: (_heightScreen / 2 >= 300) ? 2 : 1,
              childAspectRatio: (_heightScreen / 2 >= 300) ? 4 / 6.5 : 1,
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
              mainAxisExtent: 270.0
          ),
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          itemCount: this._response!.length,
          itemBuilder: (context, index) {
            return ItemBox(
              userID: this._userID,
              title: "${this._response?[index].title}",
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => ProductDetail(id: "${this._response?[index].id}"))
              ),
              cartCallback: () {
                EasyLoading.showSuccess("Add to cart");
                DatabaseManager().insertCart(
                    cart: Cart(
                        productID: "${this._response?[index].id}",
                        productName: "${this._response?[index].title.toString()}",
                        productQuantity: 1,
                        productThumbnails: "${this._response?[index].thumbnail}",
                        productPrice: "${this._response?[index].price.toString()}",
                        userID: this._userID
                    )
                ).then((value){
                  Future.delayed(
                    const Duration(seconds: 1),
                        () => EasyLoading.dismiss(),
                  );
                });
              },
              price: "${this._response?[index].price}",
              productQuantity: 1,
              productID: "${this._response?[index].id}",
              thumbnails: "${this._response?[index].thumbnail}",
            );
          },
        ),
      );
    }
  }
}