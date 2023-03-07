/*
 * Model of address
 */

class Address {
  String ? addressLineOne;
  String ? addressLineTwo;
  String ? zipCode;
  String ? city;
  String ? country;
  String ? type;
  bool isDefault;
  bool isPickup;
  bool isShipping;
  String ? userID;

  Address({
    this.addressLineOne,
    this.addressLineTwo,
    this.zipCode,
    this.city,
    this.country,
    this.type,
    this.isDefault = false,
    this.isPickup = false,
    this.isShipping = false,
    this.userID
  });

  factory Address.formJson(Map<String, dynamic> json) {
    return Address(
      addressLineOne: json['addressLineOne'],
      addressLineTwo: json['addressLineTwo'],
      zipCode: json['zipCode'],
      city: json['city'],
      country: json['country'],
      type: json['type'],
      isPickup: json['isPickup'],
      isDefault: json['isDefault'],
      isShipping: json['isShipping'],
      userID: json['userID']
    );
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'addressLineOne': addressLineOne,
      'addressLineTwo': addressLineTwo,
      'zipCode': zipCode,
      'city': city,
      'country': country,
      'type': type,
      'isPickup': (isPickup) ? 1 : 0,
      'isDefault': (isDefault) ? 1 : 0,
      'isShipping': (isShipping) ? 1 : 0,
      'userID' : userID
    };
    return map;
  }
}