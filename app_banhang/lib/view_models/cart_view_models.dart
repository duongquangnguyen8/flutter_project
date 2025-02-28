import 'dart:convert';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CartViewModels extends ChangeNotifier {
  final String _baseUrl = 'http://192.168.0.102:3000/cart';
  List<dynamic> _listProduct = [];
  List<dynamic> get listProduct => _listProduct;
  List<dynamic> _listQuantities = [];
  List<dynamic> get listQuantities => _listQuantities;
  dynamic _priceProductCart = 0;
  get priceProductCart => _priceProductCart;
  Future<void> addCart(productId, quantity, price) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final String? userId = preferences.getString('idUser');
    try {
      final url = Uri.parse(_baseUrl + '/postCart');
      var objCart = {
        'userId': userId,
        'productId': productId,
        'quantity': quantity,
        'price': price
      };
      final response = await http.post(url,
          headers: {'Content-Type': 'Application/json'},
          body: json.encode(objCart));
      if (response.statusCode == 200) {
        print('add cart success');
        notifyListeners();
      } else {
        print('add cart failed');
      }
    } catch (error) {
      print(error);
    }
  }

  Future<void> getCartByUserId() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final String? userId = preferences.getString('idUser');
    try {
      final url = Uri.parse('${_baseUrl}/getCartByUserId/${userId}');
      final response =
          await http.get(url, headers: {'Content-Type': 'Application/json'});
      if (response.statusCode == 200) {
        final responseData = await json.decode(response.body);
        var listCart = responseData['data'];
        _listQuantities.clear();
        _listProduct.clear();
        _priceProductCart = 0;
        for (var item in listCart) {
          _listProduct.add(item['productId']);
          _listQuantities.add(item['quantity']);
          _priceProductCart += item['price'];
        }
        print(priceProductCart);
        notifyListeners();
      } else {
        print('Get Cart Failed');
      }
    } catch (error) {
      print(error);
    }
  }
}
