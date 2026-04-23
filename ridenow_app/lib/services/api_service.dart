import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/vehicle_model.dart';

class ApiService {
  final String baseUrl = "http://10.0.2.2:3000/api";

  Future<String?> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email, "password": password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', data['token']);
      return data['token'];
    }
    return null;
  }

  Future<Map<String, dynamic>> register(String name, String email, String password, String phone) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/register'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "fullname": name,
          "email": email,
          "password": password,
          "phone": phone
        }),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        return {'success': true, 'message': 'Đăng ký thành công'};
      } else {
        final data = jsonDecode(response.body);
        return {'success': false, 'message': data['message'] ?? 'Đăng ký thất bại'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Lỗi kết nối server'};
    }
  }

  Future<List<Vehicle>> getVehicles() async {
    final response = await http.get(Uri.parse('$baseUrl/vehicles'));
    if (response.statusCode == 200) {
      List data = jsonDecode(response.body);
      return data.map((json) => Vehicle.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load vehicles');
    }
  }

  Future<bool> createOrder(
      int userId,
      int vehicleId,
      String startDate,
      String endDate,
      bool hasDriver,
      String deliveryType,
      double totalPrice) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final response = await http.post(
      Uri.parse('$baseUrl/orders'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      },
      body: jsonEncode({
        "user_id": userId,
        "vehicle_id": vehicleId,
        "start_date": startDate,
        "end_date": endDate,
        "has_driver": hasDriver,
        "delivery_type": deliveryType,
        "total_price": totalPrice
      }),
    );
    return response.statusCode == 201;
  }
}