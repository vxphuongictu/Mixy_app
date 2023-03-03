/*
 * Model of country
 * Api for this model: https://restcountries.com/v3.1/all
 */

class Country {
  String common;
  String official;

  Country({required this.common, required this.official});

  factory Country.fromJson(Map<String, dynamic> json)
  {
    return Country(
        common: json['common'],
        official: json['official'],
    );
  }
}