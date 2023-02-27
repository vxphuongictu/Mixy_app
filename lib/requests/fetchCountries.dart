import 'dart:convert';
import 'package:food_e/core/_config.dart' as cnf;
import 'package:http/http.dart' as http;
import 'package:food_e/models/Country.dart';


Future<dynamic> fetchCountries() async {
  
  List<Country> listCountries = [];


  final response = await http.get(
      Uri.parse("${cnf.country_uri_api}"),
  );
  if (response.statusCode != 200) {
    throw Exception('Failed to fetch data');
  }
  final data = json.decode(response.body);
  for (var item in data) {
    if (item['name']['common'].toString().length < 20) {
      listCountries.add(Country.fromJson(item['name']));
    }
  }
  listCountries.sort((a, b) => a.common.compareTo(b.common));
  return listCountries;
}