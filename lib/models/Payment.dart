/*
 * Model of payment
 */

class Payment {
  String ? cardNumber;
  String ? expiryDate;
  String ? cvv;
  bool ? isDefault;
  String ? userID;

  Payment({
    this.cardNumber,
    this.expiryDate,
    this.cvv,
    this.isDefault = false,
    this.userID
  });

  factory Payment.formJson(Map<String, dynamic> json) {
    return Payment(
        cardNumber: json['cardNumber'],
        expiryDate: json['expiryDate'],
        cvv: json['cvv'],
        isDefault: json['isDefault'],
        userID: json['userID']
    );
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'cardNumber': cardNumber,
      'expiryDate': expiryDate,
      'cvv': cvv,
      'isDefault': (isDefault == true) ? 1 : 0,
      'userID': userID
    };
    return map;
  }
}