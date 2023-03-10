import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:food_e/functions/toColor.dart';
import 'package:food_e/core/_config.dart' as cnf;
import 'package:food_e/provider/ThemeModeProvider.dart';
import 'package:food_e/widgets/BaseScreen.dart';
import 'package:food_e/widgets/LargeButton.dart';
import 'package:food_e/widgets/MyTitle.dart';
import 'package:food_e/functions/card/card.dart';
import 'package:food_e/widgets/SwitchGroup.dart';
import 'package:provider/provider.dart';
import 'package:food_e/core/SharedPreferencesClass.dart';


class PaymentSetup extends StatefulWidget
{

  String ? title;
  String ? checkOutTotalPrice;

  PaymentSetup({
    this.title,
    this.checkOutTotalPrice
  });

  @override
  State<PaymentSetup> createState() => _PaymentSetupState();
}

class _PaymentSetupState extends State<PaymentSetup> {

  /// define userID
  String _userID = "";

  /// define SharedPreferencesClass
  SharedPreferencesClass _shared = SharedPreferencesClass();

  final listCountry = const [DropdownMenuItem(child: Text("Country"),value: "Country")];

  double _scale = 0.0;

  // text controller
  CardFormEditController controller = CardFormEditController();

  bool setAsDefaultSwitch = false;

  void setAsDefault(bool action)
  {
    setState(() {
      this.setAsDefaultSwitch = action;
    });
  }

  @override
  void initState() {
    Future.delayed(const Duration(seconds: 1), () => setState((){
      this._scale = 0.8;
    }));

    _shared.get_user_info().then((value) {
      setState(() {
        this._userID = value.userID;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeModeProvider>(
      builder: (context, value, child) {
        return BaseScreen(
          appbar: true,
          scroll: false,
          appbarBgColor: (value.darkmode == true) ? cnf.darkModeColorbg.toColor() : Colors.white,
          extendBodyBehindAppBar: false,
          screenBgColor: cnf.colorWhite,
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(
              Icons.close,
              color: (value.darkmode == true) ? cnf.colorWhite.toColor() : cnf.colorBlack.toColor(),
            ),
          ),
          margin: true,
          body: paymentSetupScreen(),
        );
      },
    );
  }

  Widget paymentSetupScreen()
  {
    return Consumer<ThemeModeProvider>(
      builder: (context, value, child) {
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MyTitle(
                label: (this.widget.title == null) ? "PAYMENT SETUP" : this.widget.title!,
                color: (value.darkmode == true) ? cnf.colorWhite : cnf.colorBlack,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * .42,
                child: AnimatedScale(
                  scale: this._scale,
                  duration: const Duration(milliseconds: 200),
                  child: Image.asset("assets/images/payment.png"),
                ),
              ),
              this.formInput(),
            ],
          ),
        );
      },
    );
  }

  Widget formInput()
  {
    return Consumer<ThemeModeProvider>(
      builder: (context, value, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            CardFormField(
              controller: this.controller,
              style: CardFormStyle(
                backgroundColor: Colors.white70,
                textColor: (value.darkmode == true) ? cnf.wcWhiteText.toColor() : cnf.colorLightBlack.toColor(),
                placeholderColor: (value.darkmode == true) ? cnf.wcWhiteText.toColor() : cnf.colorLightBlack.toColor(),
                borderColor: (value.darkmode == true) ? cnf.wcWhiteText.toColor() : cnf.colorLightBlack.toColor(),
              ),
              autofocus: false,
              dangerouslyGetFullCardDetails: true,
              dangerouslyUpdateFullCardDetails: true,
            ),
            SwitchGroup(callback: setAsDefault, label: "Set as default", lableColor: (value.darkmode==true) ? cnf.colorWhite : null,isOn: setAsDefaultSwitch),
            Padding(
              padding: const EdgeInsets.only(top: cnf.wcLogoMarginTop, bottom: cnf.wcLogoMarginTop),
              child: LargeButton(
                onTap: () {
                  if (this.controller.details.complete == true) {
                    handleAddCard(
                        context: context,
                        title: this.widget.title,
                        cvv: this.controller.details.cvc,
                        expiryDate: "${this.controller.details.expiryMonth}/${this.controller.details.expiryYear}",
                        cardNumber: this.controller.details.number,
                        isDefault: this.setAsDefaultSwitch,
                        checkOutTotalPrice: this.widget.checkOutTotalPrice,
                        userID: this._userID
                    );
                  } else {
                    EasyLoading.showError("Please input validate card information");
                  }
                },
                label: "Add card",
              ),
            ),
            if (this.widget.title == null) Padding(
              padding: const EdgeInsets.only(top: cnf.wcLogoMarginTop, bottom: cnf.wcLogoMarginTop),
              child: LargeButton(
                label: "Skip for now",
                buttonColor: cnf.colorWhite,
                textColor: cnf.colorGray,
                fontWeight: FontWeight.w500,
                fontFamily: 'Poppins',
                fontSize: 14.0,
                buttonShadow: false,
                borderColor: cnf.colorWhite,
                borderWidth: 0.0,
                buttonHeight: 20.0,
              ),
            )
          ],
        );
      },
    );
  }
}