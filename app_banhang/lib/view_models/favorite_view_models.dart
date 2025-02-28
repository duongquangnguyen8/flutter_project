import 'dart:convert';

import 'package:app_banhang/models/favorite.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoriteViewModels extends ChangeNotifier {
  final String _baseUrl = 'http://192.168.0.101:3000/favorite';
  FavoriteModel? _favorite;
  FavoriteModel? get favorite => _favorite;
  List<FavoriteModel> _listFavorite = [];
  List<String> _listProductId = [];

  List<String> get listProductId => _listProductId;
  String? _favoriteId;
  String? get favoriteId => _favoriteId;
  Future<void> postFavorite(FavoriteModel newFavorite) async {
    final url = Uri.parse('${_baseUrl}/post_favorite');

    final response = await http.post(url,
        headers: {
          'Content-Type': 'Application/json',
        },
        body: json.encode(newFavorite.toJson())); //encode để chuyển sang json
    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      _favorite = FavoriteModel.fromJson(responseData['data']);
      notifyListeners();
    } else {
      throw Exception('Failed');
    }
  }

  Future<void> checkStateFavorite(
      String idProduct, String idUser, Function setFavorite) async {
    final url = Uri.parse('${_baseUrl}/get_favorite_productDetail');
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final String? _token = preferences.getString('token');
    final response = await http.post(url,
        headers: {
          'Content-Type': 'Application/Json',
          'Authorization': 'Bearer ${_token}'
        },
        body: json.encode({'userId': idUser, 'productId': idProduct}));

    if (response.statusCode == 200) {
      setFavorite(true);
      notifyListeners();
    } else if (response.statusCode == 401) {
      throw Exception('No token provided');
    } else if (response.statusCode == 403) {
      throw Exception('Invalid token or token expired');
    } else {
      setFavorite(false);
      throw Exception('Failed');
    }
  }

  Future<void> deleteFavorite(String id) async {
    final url = Uri.parse('${_baseUrl}/delete_favorite_byId/${id}');
    final response = await http.delete(url, headers: {
      'Content-Type': 'Application/Json',
    });
    if (response.statusCode == 200) {
      notifyListeners();
    } else {
      throw Exception('Failed Delete Favorite');
    }
  }

  Future<void> getFavorite() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? userId = preferences.getString('idUser');
    String? token = preferences.getString('token');
    _listProductId.clear();
    try {
      final url = Uri.parse('$_baseUrl/get_favorite_by_userId/${userId}');
      final response = await http.get(url, headers: {
        'Content-Type': 'Application/Json',
        'Authorization': 'Bearer $token '
      });
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);

        _listFavorite = (responseData['data'] as List)
            .map((item) => FavoriteModel.fromJson(item))
            .toList();
        for (var item in _listFavorite) {
          _listProductId.add(item.getProductId);
        }
        notifyListeners();
      } else if (response.statusCode == 401) {
        throw Exception('No token provided');
      } else if (response.statusCode == 403) {
        throw Exception('Invalid token or token expired');
      } else {
        throw Exception('Failed get favorite ');
      }
    } catch (error) {
      throw error;
    }
  }

  Future<void> getIdFavorite(productId) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    final String? userId = preferences.getString('idUser');
    try {
      final url = Uri.parse(_baseUrl + '/getIdFavorite');
      final response = await http.post(url,
          headers: {'Content-Type': 'Application/json'},
          body: json.encode({'userId': userId, 'productId': productId}));
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        var idfavorite = responseData['data']['_id'];
        _favoriteId = idfavorite;
        print(idfavorite);
        notifyListeners();
      } else {
        print('failed');
      }
    } catch (error) {
      print(error);
    }
  }
}
