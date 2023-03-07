import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:food_e/models/Cart.dart';
import 'package:food_e/models/Favourites.dart';
import 'package:food_e/provider/BasketProvider.dart';
import 'package:food_e/provider/LikedProvider.dart';
import 'package:food_e/provider/ThemeModeProvider.dart';
import 'package:food_e/screens/product/ProductDetail.dart';
import 'package:food_e/widgets/BaseScreen.dart';
import 'package:food_e/widgets/MyText.dart';
import 'package:food_e/widgets/MyTitle.dart';
import 'package:food_e/core/_config.dart' as cnf;
import 'package:food_e/widgets/CartItem.dart';
import 'package:provider/provider.dart';
import 'package:food_e/core/SharedPreferencesClass.dart';


class Liked extends StatefulWidget
{
  @override
  State<StatefulWidget> createState() {
    return _Liked();
  }
}


class _Liked extends State<Liked>
{

  /// define userID
  String _userID = "";

  /// define SharedPreferencesClass
  SharedPreferencesClass _shared = SharedPreferencesClass();

  @override
  void initState() {
    _shared.get_user_info().then((value) {
      setState(() {
        this._userID = value.userID;
        Provider.of<LikedProvider>(context, listen: false).fetchLiked(userID: this._userID);
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      appbar: false,
      extendBodyBehindAppBar: false,
      disabledBodyHeight: true,
      scroll: true,
      body: _likedScreen(),
    );
  }

  Widget _favouriteIsEmpty()
  {
    return SizedBox(
      width: double.infinity,
      height: MediaQuery.of(context).size.height,
      child: Center(
        child: Image.asset("assets/images/favourite-empty.png"),
      ),
    );
  }


  Widget _likedScreen()
  {
    return Consumer<LikedProvider>(
      builder: (context, value, child) {
        if (value.liked.length > 0) {
          return Padding(
            padding: const EdgeInsets.only(top: cnf.wcLogoMarginTop),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      left: cnf.wcLogoMarginLeft, right: cnf.wcLogoMarginLeft),
                  child: Row(
                      children: [
                        Consumer<ThemeModeProvider>(
                          builder: (context, value, child) {
                            return MyTitle(
                              label: 'LIKED',
                              color: (value.darkmode == true)
                                  ? cnf.colorWhite
                                  : cnf.colorBlack,
                            );
                          },
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              EasyLoading.show(status: "Waiting ...");
                              Provider.of<LikedProvider>(context, listen: false).clearLiked(userID: this._userID);
                              EasyLoading.showSuccess("Done");
                            },
                            child: MyText(
                              text: "Clear All",
                              color: cnf.colorGray,
                              align: TextAlign.right,
                              fontSize: 15.0,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        )
                      ]
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: cnf.marginScreen, right: cnf.marginScreen),
                  child: this.listCart(),
                )
              ],
            ),
          );
        } else {
          return _favouriteIsEmpty();
        }
      },
    );
  }

  Widget listCart()
  {
    return Consumer<LikedProvider>(
      builder: (context, value, child) {
        List<Favourites> _item = value.liked;
        return AnimationLimiter(
          child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _item.length,
              itemBuilder: (context, index) {
                return AnimationConfiguration.staggeredList(
                  position: index,
                  duration: const Duration(milliseconds: 500),
                  child: SlideAnimation(
                    verticalOffset: 50.0,
                    child: FadeInAnimation(
                      child: GestureDetector(
                        onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => ProductDetail(id: _item[index].idFavourite.toString()))
                        ),
                        child: CartItem(
                          screentype: 1,
                          title: "${_item[index].nameFavourite}",
                          thumbnails: Image.network(_item[index].thumbnailFavourite.toString()),
                          price: "${_item[index].priceFavourite}",
                          basketOnClick: () async {
                            EasyLoading.showSuccess("Add to cart");
                            Provider.of<BasketProvider>(context, listen: false).addCart(
                                Cart(
                                    productID: _item[index].idFavourite.toString(),
                                    productName: "${_item[index].nameFavourite}",
                                    productQuantity: 1,
                                    productThumbnails: _item[index].thumbnailFavourite.toString(),
                                    productPrice: "${_item[index].priceFavourite.toString()}",
                                    userID: this._userID,
                                )
                            );
                            Future.delayed(
                              const Duration(seconds: 1),
                                  () => EasyLoading.dismiss(),
                            );
                          },
                          onDelete: () async {
                            EasyLoading.showSuccess("Deleted");
                            Provider.of<LikedProvider>(context, listen: false).removeLiked(id: _item[index].idFavourite.toString(), userID: this._userID);
                            Future.delayed(
                              const Duration(seconds: 1),
                                  () => EasyLoading.dismiss(),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                );
              }
          ),
        );
      },
    );
  }
}