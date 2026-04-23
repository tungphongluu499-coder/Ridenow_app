import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AuthProvider with ChangeNotifier {
  String? _token;
  
  // URL của Backend (Thay localhost bằng 10.0.2.2 cho máy ảo Android)
  final String baseUrl = "http://10.0.2.2:3000/api/auth";

  bool get isAuth => _token != null;

  Future<void> register(String fullname, String email, String password, String phone) async {
    final url = Uri.parse('$baseUrl/register');
    try {
      await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'fullname': fullname,
          'email': email,
          'password': password,
          'phone': phone,
        }),
      );
    } catch (error) {
      throw error;
    }
  }

  Future<bool> login(String email, String password) async {
    final url = Uri.parse('$baseUrl/login');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email, 'password': password}),
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        _token = data['token'];
        notifyListeners(); // Thông báo cho UI cập nhật
        return true;
      }
      return false;
    } catch (error) {
      return false;
    }
  }
}