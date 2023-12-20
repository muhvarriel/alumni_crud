import 'dart:convert';
import 'dart:developer';

import 'package:movie_mobile/ui/model_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ListDatabase {
  static Future<List<String>> readString() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    String? json = prefs.getString("list_string");

    log("readString: $json");

    if (json != null && json.isNotEmpty) {
      List<dynamic> dynamicList = jsonDecode(json);
      List<String> list = dynamicList.map((e) => e.toString()).toList();
      return list;
    } else {
      return [];
    }
  }

  static Future<List<String>> createString(String data) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    List<String> list = await readString();

    list.add(data);

    await prefs.setString("list_string", jsonEncode(list));

    return list;
  }

  static Future<List<String>> updateString(String data, int index) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    List<String> list = await readString();

    list[index] = data;

    await prefs.setString("list_string", jsonEncode(list));

    return list;
  }

  static Future<List<String>> deleteString(int index) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    List<String> list = await readString();

    list.removeAt(index);

    await prefs.setString("list_string", jsonEncode(list));

    return list;
  }

  static Future<List<Product>> readProduct() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    String? json = prefs.getString("list_product");

    log("readProduct: $json");

    if (json != null && json.isNotEmpty) {
      List<dynamic> dynamicList = jsonDecode(json);
      List<Product> list = dynamicList.map((e) => Product.fromJson(e)).toList();
      return list;
    } else {
      return [];
    }
  }

  static Future<List<Product>> createProduct(Product data) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    List<Product> list = await readProduct();

    list.add(data);

    await prefs.setString("list_product", jsonEncode(list));

    return list;
  }

  static Future<List<Product>> updateProduct(Product data, int index) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    List<Product> list = await readProduct();

    list[index] = data;

    await prefs.setString("list_product", jsonEncode(list));

    return list;
  }

  static Future<List<Product>> deleteProduct(int index) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    List<Product> list = await readProduct();

    list.removeAt(index);

    await prefs.setString("list_product", jsonEncode(list));

    return list;
  }
}
