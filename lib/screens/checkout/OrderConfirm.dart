import 'package:flutter/material.dart';
import 'package:food_e/functions/toColor.dart';
import 'package:food_e/provider/ThemeModeProvider.dart';
import 'package:food_e/screens/cart/OrderHistory.dart';
import 'package:food_e/widgets/BaseScreen.dart';
import 'package:food_e/core/_config.dart' as cnf;
import 'package:food_e/widgets/LargeButton.dart';
import 'package:food_e/widgets/MyText.dart';
import 'package:food_e/widgets/MyTitle.dart';
import 'package:provider/provider.dart';


class OrderConfirm extends StatefulWidget
{
  @override
  State<OrderConfirm> createState() {
    return _OrderConfirm();
  }
}

class _OrderConfirm extends State<OrderConfirm>
{
  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      scroll: false,
      extendBodyBehindAppBar: true,
      margin: false,
      body: _screen(),
    );
  }


  Widget _screen()
  {
    return Consumer<ThemeModeProvider>(
      builder: (context, value, child) {
        return Container(
          color: cnf.colorGreen.toColor(),
          child: Column(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    MyTitle(
                      label: "ORDER CONFIRMED!",
                      color: cnf.colorWhite,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 50.0, bottom: 50.0),
                      child: Image.asset('assets/images/orderconfirm.png'),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: cnf.marginScreen, right: cnf.marginScreen),
                      child: MyText(
                        text: "Hang on Tight! We’ve received your order and we’ll bring it to you ASAP!",
                        align: TextAlign.center,
                        fontWeight: FontWeight.w500,
                        fontSize: 14.0,
                        color: cnf.colorWhite,
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: cnf.wcLogoMarginTop, left: cnf.marginScreen, right: cnf.marginScreen),
                child: LargeButton(
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => OrderHistory())),
                  label: "TRACK MY ORDER",
                  textColor: (value.darkmode == true) ? cnf.wcWhiteText : cnf.colorMainStreamBlue,
                  buttonColor: (value.darkmode == true) ? cnf.colorMainStreamBlue : cnf.colorWhite,
                  buttonShadow: false,
                ),
              )
            ],
          ),
        );
      },
    );
  }
}