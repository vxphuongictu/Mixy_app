import 'package:banner_carousel/banner_carousel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:food_e/functions/toColor.dart';
import 'package:food_e/provider/BasketProvider.dart';
import 'package:food_e/provider/ThemeModeProvider.dart';
import 'package:food_e/widgets/BaseScreen.dart';
import 'package:food_e/widgets/LargeButton.dart';
import 'package:food_e/widgets/MyInput.dart';
import 'package:food_e/widgets/MyReadMoreText.dart';
import 'package:food_e/widgets/MyText.dart';
import 'package:food_e/core/_config.dart' as cnf;
import 'package:food_e/widgets/MyTitle.dart';
import 'package:food_e/functions/products/quantity.dart';
import 'package:food_e/widgets/ButtonContainer.dart';
import 'package:food_e/requests/getProductDetail.dart';
import 'package:food_e/models/ProductDetails.dart';
import 'package:food_e/widgets/Loading.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:food_e/models/Cart.dart';
import 'package:food_e/core/SharedPreferencesClass.dart';


class ProductDetail extends StatefulWidget
{

  String id;
  ProductDetail({required this.id});

  @override
  State<ProductDetail> createState() => _ProductDetailState();

}


class _ProductDetailState extends State<ProductDetail>
{
  /// screen config
  final spaceFromTitleToBanner = 20.0;
  final spaceFromDescToTitle = 30.0;
  final spaceFromDescToContent = 10.0;
  final spaceFromContentToQuantity = 40.0;
  final spaceFromQuantityToMargin = 20.0;
  final spaceFromQuantityTitleToInput = 5.0;
  final appbarIconSize = 18.0;

  /// define _productDetails as Future
  late Future<ProductDetails> _productDetails;

  /// define quantity input
  TextEditingController quantityController = TextEditingController();

  /// define list of banner
  List<BannerModel> listBanner = [];

  /// define title to share
  String ? _titleOfShare = 'Share Me';
  String ? _contentOfShare = 'Vu Xuan Phuong';

  /// define userID
  late String _userID;

  /// define SharedPreferencesClass
  SharedPreferencesClass _shared = SharedPreferencesClass();


  @override
  void initState() {
    _shared.get_user_info().then((value) {
      setState(() {
        this._userID = value.userID;
      });
    });

    this._productDetails = product_detail(id: this.widget.id);
    this._productDetails.then((value) => setState((){
      this._titleOfShare = value.title;
      this._contentOfShare = value.content;
    }));
    setState(() {
      this.quantityController.text = "1";
    });
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      appbar: false,
      screenBgColor: cnf.colorWhite,
      disabledBodyHeight: true,
      scroll: true,
      body: _details(),
    );
  }

  Widget _details()
  {
    return Consumer<ThemeModeProvider>(
      builder: (context, value, child) {
        return FutureBuilder(
          future: this._productDetails,
          builder: (context, snapshot) {
            final data = snapshot.data;
            if (snapshot.hasData) {
              if (this.listBanner.isEmpty) {
                for (var i = 0; i < data!.galleryImages!.length; i ++) {
                  this.listBanner.add(
                      BannerModel(
                          imagePath: data.galleryImages![i]['sourceUrl'],
                          id: (i + 1).toString(),
                          boxFit: BoxFit.cover)
                  );
                }
              }
              return Column(
                children: [
                  Stack(
                    children: [
                      BannerCarousel.fullScreen(
                        banners: listBanner,
                        customizedIndicators: const IndicatorModel.animation(
                          width: 10,
                          height: 5,
                          spaceBetween: 2,
                          widthAnimation: 20,
                        ),
                        height: 300.0,
                        activeColor: Colors.amberAccent,
                        disableColor: Colors.white,
                        animation: true,
                        indicatorBottom: false,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: cnf.wcLogoMarginTop, left: cnf.marginScreen, right: cnf.marginScreen),
                        child: Row(
                          children: [
                            Expanded(
                              child: ButtonContainer(childWidget: Icon(Icons.keyboard_arrow_left, size: this.appbarIconSize, color: cnf.colorWhite.toColor()), onTap: () => Navigator.pop(context)),
                            ),
                            ButtonContainer(
                                onTap: () async {
                                  await Share.share(this._contentOfShare!, subject: this._titleOfShare);
                                },
                                childWidget: FaIcon(
                                    FontAwesomeIcons.list,
                                    size: this.appbarIconSize,
                                    color: cnf.colorWhite.toColor())
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.only(left: cnf.wcLogoMarginLeft, right: cnf.wcLogoMarginLeft, top: this.spaceFromTitleToBanner),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: MediaQuery.of(context).size.width / 2,
                                  child: MyTitle(
                                    maxLines: 1,
                                    textOverflow: true,
                                    align: TextAlign.left,
                                    color: (value.darkmode == true) ? cnf.colorWhite : cnf.colorLightBlack,
                                    label: "${data?.title}",
                                    fontSize: 36,
                                  ),
                                ),
                                MyText(
                                  color: cnf.colorOrange,
                                  fontSize: 14,
                                  text: "The Nautilus",
                                )
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Icon(
                                  Icons.access_time,
                                  color: cnf.colorOrange.toColor(),
                                ),
                                MyText(
                                  color: cnf.colorOrange,
                                  fontSize: 14,
                                  text: "34 mins",
                                )
                              ],
                            )
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: this.spaceFromDescToTitle,
                              bottom: this.spaceFromDescToContent),
                          child: MyTitle(
                            fontSize: 18,
                            label: 'DESCRIPTION',
                            color: cnf.colorLightGrayShadow,
                          ),
                        ),
                        Consumer<ThemeModeProvider>(
                          builder: (context, value, child) {
                            return Padding(
                              padding: EdgeInsets.only(bottom: this.spaceFromContentToQuantity),
                              child: MyReadMoreText(
                                  showMore: "Read more",
                                  showLess: "Read less",
                                  textColor: (value.darkmode == true) ? cnf.colorWhite : cnf.colorLightBlack,
                                  trimLines: 8,
                                  fontSize: 14,
                                  text: '${data?.content}'
                              ),
                            );
                          },
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(
                                      left: this.spaceFromQuantityToMargin,
                                      bottom: this.spaceFromQuantityTitleToInput),
                                  child: MyTitle(
                                    fontSize: 18,
                                    label: 'QUANTITY',
                                    color: cnf.colorMainStreamBlue,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.only(
                                    right: 20,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                        cnf.input_radius),
                                    color: cnf.colorGrayInputBg.toColor(),
                                  ),
                                  child: Row(
                                    children: [
                                      MyInput(
                                        textController: this.quantityController,
                                        width: 100.0,
                                        isNumber: true,
                                        boder: false,
                                        textColor: cnf.colorGray,
                                      ),
                                      SizedBox(
                                        width: 25.0,
                                        child: IconButton(
                                            iconSize: 15.0,
                                            padding: EdgeInsets.zero,
                                            onPressed: () {
                                              setState(() {
                                                this.quantityController.text = remove(currentNumber: int.parse(this.quantityController.text)).toString();
                                              });
                                            },
                                            icon: FaIcon(
                                              FontAwesomeIcons.minus,
                                              color: cnf.colorMainStreamBlue
                                                  .toColor(),
                                            )
                                        ),
                                      ),
                                      SizedBox(
                                        width: 25.0 ,
                                        child: IconButton(
                                            iconSize: 15.0,
                                            padding: EdgeInsets.zero,
                                            onPressed: () {
                                              setState(() {
                                                this.quantityController.text =
                                                    add(currentNumber: int.parse(
                                                        this.quantityController
                                                            .text)).toString();
                                              });
                                            },
                                            icon: FaIcon(
                                              FontAwesomeIcons.plus,
                                              color: cnf.colorMainStreamBlue
                                                  .toColor(),
                                            )
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                MyTitle(
                                  fontSize: 18,
                                  label: 'SUB TOTAL',
                                  color: cnf.colorLightBlack,
                                ),
                                MyTitle(
                                  fontSize: 24,
                                  label: '${data?.price}',
                                  color: cnf.colorMainStreamBlue,
                                )
                              ],
                            )
                          ],
                        ),
                        Container(
                            height: cnf.large_button_h,
                            margin: const EdgeInsets.only(top: cnf.wcLogoMarginTop, bottom: cnf.wcLogoMarginTop),
                            alignment: Alignment.bottomCenter,
                            child: LargeButton(
                              onTap: () async {
                                EasyLoading.show(status: "Wating ...");
                                Provider.of<BasketProvider>(context, listen: false).addCart(
                                  Cart(
                                    productID: this.widget.id,
                                    productName: "${data?.title}",
                                    productQuantity: int.parse(this.quantityController.text),
                                    productPrice: "${data?.price}",
                                    productThumbnails: "${data?.galleryImages![0]['sourceUrl']}",
                                    userID: this._userID
                                  ),
                                );
                                EasyLoading.showSuccess("Add to cart");
                              },
                              label: "ADD TO BASKET",
                            )
                        )
                      ],
                    ),
                  )
                ],
              );
            } else {
              return SizedBox(
                width: double.infinity,
                height: MediaQuery.of(context).size.height,
                child: Center(
                  child: Loading(),
                ),
              );
            }
          },
        );
      },
    );
  }
}
