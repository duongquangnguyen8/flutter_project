import 'dart:convert';

import 'package:app_banhang/models/user.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthViewModels extends ChangeNotifier {
  final String baseUrl = 'http://192.168.0.102:3000/user';
  UserModel? _user;
  UserModel? get user => _user;
  Future<void> register(UserModel newUser) async {
    final url = Uri.parse('$baseUrl/register');
    final response = await http.post(url,
        headers: {
          'Content-Type': 'Application/json',
        },
        body: json.encode(newUser.toJson()));
    if (response.statusCode == 200) {
      _user = newUser;
      notifyListeners();
    } else if (response.statusCode == 400) {
      throw Exception('Email is already exists');
    } else {
      throw Exception('Failed to register');
    }
  }

  Future<void> login(String email, String password) async {
    final url = Uri.parse('$baseUrl/login');
    final response = await http.post(url,
        headers: {
          'Content-Type': 'Application/json',
        },
        body: json.encode({
          //encode để chuyển đổi đối tượng sang json
          'email': email,
          'password': password,
        }));
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      String token = responseData['token'];
      String idUser = responseData['idUser'];
      SharedPreferences preferences = await SharedPreferences.getInstance();
      await preferences.setString('token', token);
      await preferences.setString('idUser', idUser);
      Fluttertoast.showToast(msg: 'Đăng nhập thành công');
    } else if (response.statusCode == 400) {
      throw Exception('Invalid credentials');
    } else {
      throw Exception('Sever Error');
    }
  }

  Future<void> forgotPassword(String email) async {
    final url = Uri.parse('$baseUrl/forgot_password');
    final response = await http.post(url,
        headers: {
          'Content-Type': 'Application/json',
        },
        body: json.encode({
          'email': email,
        }));
    if (response.statusCode == 200) {
      Fluttertoast.showToast(msg: 'OTP đã được gửi về email của bạn');
      notifyListeners();
    } else if (response.statusCode == 400) {
      throw Exception('Not found or exists');
    } else {
      throw Exception('Sever Error');
    }
  }

  Future<void> verifyOTP(String email, String otp) async {
    final url = Uri.parse('$baseUrl/verify_otp');
    final respose = await http.post(url,
        headers: {'Content-Type': 'Application/json'},
        body: json.encode({
          'email': email,
          'otp': otp,
        }));
    if (respose.statusCode == 200) {
      print('success otp');
      notifyListeners();
    } else if (respose.statusCode == 400) {
      throw Exception('Otp has expired or Invalid');
    } else {
      throw Exception('Sever Error');
    }
  }

  Future<void> resetPass(String email, pass) async {
    final url = Uri.parse('$baseUrl/reset_pass_word');
    final response = await http.post(url,
        headers: {
          'Content-Type': 'Application/json',
        },
        body: json.encode({
          'email': email,
          'password': pass,
        }));
    if (response.statusCode == 200) {
      Fluttertoast.showToast(msg: 'Cập nhật mật khẩu thành công');
      notifyListeners();
    } else {
      throw Exception('Server error');
    }
  }
}
