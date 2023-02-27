import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:food_e/core/DatabaseManager.dart';
import 'package:food_e/models/Payment.dart';
import 'package:food_e/screens/Payment/MyPaymentMethod.dart';
import 'package:food_e/screens/checkout/CheckOut.dart';


void handleAddCard({required BuildContext context, String ? title, String ? cardNumber, String ? expiryDate, String ? cvv, String ? checkOutTotalPrice, bool ? isDefault = false}) async
{
  if (cardNumber == "") {
    EasyLoading.showError(duration: const Duration(seconds: 3), "Card number is required");
  } else if (expiryDate == "") {
    EasyLoading.showError(duration: const Duration(seconds: 3), "Expiry date is required");
  } else if (cvv == "") {
    EasyLoading.showError(duration: const Duration(seconds: 3), "Cvv is required");
  } else {
    EasyLoading.show(status: "Waitting ...");

    if (isDefault == true) {
      await DatabaseManager().updateCard();
    }

    await DatabaseManager().insertCard(payment: Payment(
      cvv: cvv,
      cardNumber: cardNumber,
      expiryDate: expiryDate,
      isDefault: isDefault,
    ));
    await Future.delayed(
      const Duration(seconds: 3),
      () => EasyLoading.showSuccess("Done!"),
    );

    if (title == null) {
      Navigator.pushNamed(context, 'bottom-nav-bar-menu/');
    } else {
      if (checkOutTotalPrice != null) {
        Navigator.push(context, MaterialPageRoute(builder: (context) => CheckOut(totalPrice: checkOutTotalPrice)));
      } else {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => MyPaymentMethod()));
      }
    }
  }
}