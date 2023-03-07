/*
 * All table, config, queries will be here
 */

import 'dart:async';
import 'dart:convert';
import 'dart:io' as io;
import 'package:food_e/models/Favourites.dart';
import 'package:food_e/models/Payment.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:food_e/models/Products.dart';
import 'package:food_e/models/Cart.dart';
import 'package:food_e/models/Address.dart';

class DatabaseManager
{

  final String dbName = "food_app.db";
  static Database ? _db;

  // Table products config
  static const String prd_tb_name = 'products';
  static const String prd_id = 'id';
  static const String prd_name = 'name';
  static const String prd_title = 'title';
  static const String prd_thumbnail = 'thumbnail';
  static const String prd_description = 'description';
  static const String prd_price = 'price';
  static const String prd_galleryImages = 'galleryImages';

  // table cart config
  static const String cart_tb_name = 'cart';
  static const String productID = 'productID';
  static const String productName = 'productName';
  static const String productQuantity = 'productQuantity';
  static const String productThumbnails = 'productThumbnails';
  static const String productPrice = 'productPrice';
  static const String cart_userID = 'userID';

  // table favourite
  static const String favourite_tb_name = "favourites";
  static const String idFavourite = 'idFavourite';
  static const String nameFavourite = 'nameFavourite';
  static const String thumbnailFavourite = 'thumbnailFavourite';
  static const String priceFavourite = 'priceFavourite';
  static const String favourite_userID = 'userID';

  // table address
  static const String addr_tb_name = "address";
  static const String addressID = "id";
  static const String address_line_one = "addressLineOne";
  static const String address_line_two = "addressLineTwo";
  static const String zip_code = "zipCode";
  static const String city = "city";
  static const String country = "country";
  static const String address_type = "type";
  static const String address_is_default = "isDefault";
  static const String address_is_pickup = "isPickup";
  static const String address_is_shipping = "isShipping";
  static const String address_userID = "userID";


  // table card
  static const String card_tb_name = "card";
  static const String cardID = "id";
  static const String card_number = "cardNumber";
  static const String card_expiration = "expiryDate";
  static const String card_cvv = "cvv";
  static const String card_isDefault = "isDefault";
  static const String card_userID = "userID";

  Future<Database> get db async {
    if (_db != null) {
      return _db!;
    }
    _db = await initDb();
    return _db!;
  }

  initDb() async {  //init db
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, this.dbName);
    print(path);
    var db = await openDatabase(path, version: 1, onCreate: _createTable);
    return db;
  }

  _createTable(Database db, int version) async {
    /* table products */
    await db.execute("CREATE TABLE $prd_tb_name ("
        "$prd_id VARCHAR(255),"
        "$prd_name VARCHAR(255), "
        "$prd_title VARCHAR(255), "
        "$prd_description TEXT, "
        "$prd_price DOUBLE, "
        "$prd_thumbnail VARCHAR(255), "
        "$prd_galleryImages VARCHAR(255)"
        ")");

    /* table cart */
    await db.execute("CREATE TABLE $cart_tb_name ("
      "$productID VARCHAR(255),"
      "$productName VARCHAR(255),"
      "$productQuantity INT,"
      "$productThumbnails VARCHAR(255),"
      "$productPrice VARCHAR (100),"
      "$cart_userID VARCHAR (100)"
      ")");

    /* table favourite */
    await db.execute("CREATE TABLE $favourite_tb_name ("
        "$idFavourite VARCHAR(255),"
        "$nameFavourite VARCHAR(255),"
        "$thumbnailFavourite VARCHAR(255),"
        "$priceFavourite VARCHAR(100),"
        "$favourite_userID VARCHAR (100)"
        ")");

    /* table address */
    await db.execute("CREATE TABLE $addr_tb_name ("
        "$addressID INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,"
        "$address_line_one VARCHAR(255),"
        "$address_line_two VARCHAR(255),"
        "$zip_code VARCHAR(50),"
        "$city VARCHAR(100),"
        "$country VARCHAR(100),"
        "$address_type VARCHAR(50),"
        "$address_is_default INTEGER,"
        "$address_is_pickup INTEGER,"
        "$address_is_shipping INTEGER,"
        "$address_userID VARCHAR(100)"
        ")");

    /* table card */
    await db.execute("CREATE TABLE $card_tb_name ("
        "$cardID INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,"
        "$card_number VARCHAR(255),"
        "$card_expiration VARCHAR(50),"
        "$card_cvv VARCHAR(100),"
        "$card_isDefault INTEGER,"
        "$card_userID VARCHAR(100)"
        ")");
  }

  /* Table Products */
  insertProducts(Products products) async {
    final dbClient = await db;
    final insert = await dbClient.insert("${prd_tb_name}", products.toMap());
    return insert;
  }

  fetchProducts() async {
    final dbClient = await db;
    final result = await dbClient.query("${prd_tb_name}");
    return result;
  }

  deleteProducts() async {
    final dbClient = await db;
    return await dbClient.delete('${prd_tb_name}');
  }


  /* Table Cart */
  insertCart({required Cart cart}) async {
    final dbClient = await db;
    Map<String, dynamic> cart_info = json.decode(await this.checkCart(id: cart.productID, userID: cart.userID));
    if (cart_info['productID'] != "") {
      int productQuantityUpdate = int.parse(cart_info['productQuantity']) + cart.productQuantity;
      final response = await dbClient.rawUpdate('UPDATE ${cart_tb_name} SET ${productQuantity} = ? WHERE ${productID} = ? AND ${cart_userID} = ?', [productQuantityUpdate, cart.productID, cart.userID]);
      return response;
    } else {
      final response = await dbClient.insert("${cart_tb_name}", cart.toMap());
      return response;
    }
  }

  Future<List<dynamic>> fetchCart({required String userID}) async {
    final dbClient = await db;
    final result = await dbClient.query("${cart_tb_name} WHERE ${cart_userID} = ?", whereArgs: [userID]);
    return result;
  }

  checkCart({required String? id, required String userID}) async {
    final dbClient = await db;
    dynamic item = {"${productID}" : "", "${productQuantity}": ""};
    final result = await dbClient.query("${cart_tb_name}", where: '${productID} = ? AND ${cart_userID} = ?', whereArgs: [id, userID]);
    if (result.length > 0) {
      item['${productID}'] = "${result[0]['productID']}";
      item['${productQuantity}'] = "${result[0]['productQuantity']}";
    }
    return jsonEncode(item);
  }

  clearCart({required String userID}) async {
    final dbClient = await db;
    return await dbClient.delete('${cart_tb_name} where ${cart_userID} = ?', whereArgs: [userID]);
  }

  removeItemInCart({required String ? id, required String userID}) async {
    final dbClient = await db;
    return await dbClient.delete('${cart_tb_name}', where: '${productID} = ? and ${cart_userID} = ?', whereArgs: [id, userID]);
  }

  /* table favourites */
  favourite({required Favourites item}) async {
    final dbClient = await db;
    this.checkFavourite(id: item.idFavourite, userID: item.userID).then((value) async {
      if (value == true) {
        await dbClient.delete('${favourite_tb_name}', where: '${idFavourite} = ? and ${favourite_userID} = ?', whereArgs: [item.idFavourite, item.userID]);
      } else {
        await dbClient.insert('${favourite_tb_name}', item.toMap());
      }
    });
  }

  checkFavourite({required String? id, required String userID}) async {
    final dbClient = await db;
    final result = await dbClient.query("${favourite_tb_name}", where: '${idFavourite} = ? and ${favourite_userID} = ?', whereArgs: [id, userID]);
    if (result.length > 0) {
      return true;
    }
    return false;
  }

  fetchFavouriteItem({required String userID}) async {
    final dbClient = await db;
    final result = await dbClient.query("${favourite_tb_name}", where: "${favourite_userID} = ?", whereArgs: [userID]);
    return result;
  }

  removeItemInFavourite({required String id, required String userID}) async {
    final dbClient = await db;
    return await dbClient.delete('${favourite_tb_name}', where: '${idFavourite} = ? and ${favourite_userID} = ?', whereArgs: [id, userID]);
  }

  clearFavourite({required String userID}) async {
    final dbClient = await db;
    return await dbClient.delete('${favourite_tb_name}', where: "${favourite_userID} = ?", whereArgs: [userID]);
  }

  /* Table Address */
  insertAddress({required Address address}) async {
    final dbClient = await db;
    final insert = await dbClient.insert("${addr_tb_name}", address.toMap());
    return insert;
  }

  fetchAddress({required String userID}) async {
    final dbClient = await db;
    try {
      final result = await dbClient.query("${addr_tb_name}", orderBy: "${address_is_default} DESC", where: "${address_userID} = ?", whereArgs: [userID]);
      return result;
    } catch (e) {
      //
    }
    return null;
  }

  getDefaultAddress({required String userID}) async {
    final dbClient = await db;
    try {
      final result = await dbClient.query("${addr_tb_name}", where: "${address_is_default} = ? and ${address_userID} = ?", whereArgs: [1, userID]);
      return result;
    } catch (e) {
      //
    }
    return null;
  }

  updateAddress({required String userID}) async {
    final dbClient = await db;
    try {
      await dbClient.rawUpdate('UPDATE ${addr_tb_name} SET ${address_is_default} = ? WHERE ${address_userID} = ?',[0, userID]);
    } catch(e) {
      //
    }
  }

  removeAddress({required int ? id, required String userID}) async {
    final dbClient = await db;
    return await dbClient.delete('${addr_tb_name}', where: '${addressID} = ? and ${address_userID} = ?', whereArgs: [id, userID]);
  }

  /* Table Card */
  insertCard({required Payment payment}) async {
    final dbClient = await db;
    final insert = await dbClient.insert("${card_tb_name}", payment.toMap());
    return insert;
  }

  updateCard({required String userID}) async {
    final dbClient = await db;
    try {
      await dbClient.rawUpdate('UPDATE ${card_tb_name} SET ${card_isDefault} = ? and ${card_userID}', [0, userID]);
    } catch(e) {
      //
    }
  }

  fetchCard({required String userID}) async {
    final dbClient = await db;
    try {
      final result = await dbClient.query("${card_tb_name}", orderBy: "${card_isDefault} DESC", where: "${card_userID} = ?", whereArgs: [userID]);
      return result;
    } catch (e) {
      //
    }
    return null;
  }

  removeItemInCard({required int id, required String userID}) async {
    final dbClient = await db;
    return await dbClient.delete('${card_tb_name}', where: '${cardID} = ? and ${card_userID} = ?', whereArgs: [id, userID]);
  }
}