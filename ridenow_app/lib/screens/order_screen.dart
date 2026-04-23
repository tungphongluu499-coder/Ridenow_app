import 'package:flutter/material.dart';
import '../services/api_service.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  Future<void> order() async {
    try {
      await ApiService().createOrder(
        1, // userId
        1, // vehicleId
        "2026-04-21", // startDate
        "2026-04-25", // endDate
        false, // hasDriver
        "self", // deliveryType
        500.0, // totalPrice
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Đặt xe thành công")),
      );
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Order")),
      body: Center(
        child: ElevatedButton(
          onPressed: order,
          child: const Text("Đặt xe"),
        ),
      ),
    );
  }
}