import 'package:flutter/material.dart';
import '../services/api_service.dart';

class BookingListScreen extends StatefulWidget {
  const BookingListScreen({super.key});

  @override
  State<BookingListScreen> createState() => _BookingListScreenState();
}

class _BookingListScreenState extends State<BookingListScreen> {
  List bookings = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchBookings();
  }

  Future<void> fetchBookings() async {
    try {
      final data = await ApiService.getOrders();
      setState(() {
        bookings = data;
        isLoading = false;
      });
    } catch (e) {
      print("❌ Lỗi load đơn hàng: $e");
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Danh sách đặt xe"),
        leading: const BackButton(),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/login');
            },
            icon: const Icon(Icons.logout),
          )
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : bookings.isEmpty
              ? const Center(child: Text("Bạn chưa có đơn đặt xe nào"))
              : ListView.builder(
                  itemCount: bookings.length,
                  itemBuilder: (context, index) {
                    final booking = bookings[index];
                    return Card(
                      margin: const EdgeInsets.all(10),
                      child: ListTile(
                        title: Text(
                          booking['vehicleName'] ?? "Xe #${booking['vehicleID']}",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Từ: ${booking['startDate'] ?? 'N/A'}"),
                            Text("Đến: ${booking['endDate'] ?? 'N/A'}"),
                            Text(
                              "Tổng: ${booking['totalPrice'] ?? 0} VNĐ",
                              style: const TextStyle(color: Colors.green),
                            ),
                          ],
                        ),
                        isThreeLine: true,
                        trailing: Icon(
                          booking['status'] == 'confirmed'
                              ? Icons.check_circle
                              : booking['status'] == 'cancelled'
                                  ? Icons.cancel
                                  : Icons.pending,
                          color: booking['status'] == 'confirmed'
                              ? Colors.green
                              : booking['status'] == 'cancelled'
                                  ? Colors.red
                                  : Colors.orange,
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
