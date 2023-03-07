import 'package:flutter/material.dart';
import 'package:food_e/functions/toColor.dart';
import 'package:food_e/provider/ThemeModeProvider.dart';
import 'package:food_e/widgets/BaseScreen.dart';
import 'package:food_e/core/_config.dart' as cnf;
import 'package:food_e/widgets/LargeButton.dart';
import 'package:food_e/widgets/MyText.dart';
import 'package:food_e/widgets/MyTitle.dart';
import 'package:provider/provider.dart';


class OrderFailed extends StatefulWidget
{
  @override
  State<OrderFailed> createState() {
    return _OrderFailed();
  }
}

class _OrderFailed extends State<OrderFailed>
{
  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      scroll: true,
      extendBodyBehindAppBar: true,
      body: _screen(),
    );
  }


  Widget _screen()
  {
    return Consumer<ThemeModeProvider>(
      builder: (context, value, child) {
        return Container(
          color: cnf.colorLightRed.toColor(),
          child: Column(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    MyTitle(
                      label: "SOMETHING WENT WRONG!",
                      color: cnf.colorWhite,
                    ),
                    SizedBox(
                      width: 200.0,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 50.0, bottom: 50.0),
                        child: Image.asset('assets/images/orderfailed.png'),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: cnf.marginScreen, right: cnf.marginScreen),
                      child: MyText(
                        text: "Something went wrong. We’ll look into the issue right away.",
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
                padding: const EdgeInsets.only(bottom: cnf.wcLogoMarginTop, left: cnf.marginScreen, right: cnf.marginScreen, top: cnf.marginScreen),
                child: LargeButton(
                  label: "TRY AGAIN",
                  textColor: (value.darkmode == true) ? cnf.colorWhite : cnf.colorMainStreamBlue,
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