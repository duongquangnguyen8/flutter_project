import 'dart:convert';

import 'package:app_banhang/models/product.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ProductViewModels extends ChangeNotifier {
  final String url_product = 'http://192.168.0.101:3000/product';
  List<Product> _productList = [];
  Product? _product;
  Product? get product => _product;
  Future<List<Product>> getProduct() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final String? _token = preferences.getString('token');
    final url = Uri.parse('$url_product/get_all_product');
    try {
      final response = await http.get(url, headers: {
        'Content-Type': 'Application/json',
        'Authorization': 'Bearer $_token'
      });
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData is Map<String, dynamic> &&
            responseData['data'] is List<dynamic>) {
          final List<dynamic> productsJson = responseData['data'];
          _productList =
              productsJson.map((data) => Product.fromJson(data)).toList();
          //cần phai có tostring
          // mặc định in đối tượng là trả về instance of <product>
          notifyListeners();
        }
      } else if (response.statusCode == 401) {
        throw Exception('No token provided');
      } else if (response.statusCode == 403) {
        throw Exception('Invalid token or token expired');
      } else {
        throw Exception('Failed to load products');
      }
    } catch (error) {
      throw error;
    }
    return _productList;
  }

  Future<void> getProductById(id) async {
    final url = Uri.parse('$url_product/getProductById/$id');
    final response =
        await http.get(url, headers: {'Content-Type': 'application/json'});
    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      _product = Product.fromJson(responseData['data']);
    } else {
      throw Exception('Failed getProductById');
    }
  }

  void clearProduct() {
    _product = null;
    notifyListeners();
  }
}
