import 'package:flutter/material.dart';
import '../models/vehicle_model.dart';
import 'order_screen.dart';

class VehicleDetailScreen extends StatelessWidget {
  final Vehicle vehicle;

  const VehicleDetailScreen({super.key, required this.vehicle});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 250,
            pinned: true,
            backgroundColor: Colors.blueAccent,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Colors.blueAccent, Color(0xFF1565C0)],
                  ),
                ),
                child: const Center(
                  child: Icon(Icons.directions_bike, size: 120, color: Colors.white),
                ),
              ),
            ),
            leading: IconButton(
              icon: const CircleAvatar(
                backgroundColor: Colors.white24,
                child: Icon(Icons.arrow_back, color: Colors.white),
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Tên xe + Badge trạng thái
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          vehicle.name,
                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF2C3E50),
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                        decoration: BoxDecoration(
                          color: vehicle.status == 'available'
                              ? Colors.green.withOpacity(0.15)
                              : Colors.red.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          vehicle.status == 'available' ? '✅ Còn xe' : '❌ Hết xe',
                          style: TextStyle(
                            color: vehicle.status == 'available' ? Colors.green : Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Mô tả
                  Text(
                    vehicle.description.isNotEmpty ? vehicle.description : "Xe chất lượng cao, an toàn và tiện lợi.",
                    style: const TextStyle(fontSize: 15, color: Colors.grey, height: 1.5),
                  ),
                  const SizedBox(height: 24),

                  // Thông tin giá
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.monetization_on_outlined, color: Colors.blueAccent, size: 28),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Giá thuê mỗi ngày", style: TextStyle(color: Colors.grey, fontSize: 13)),
                            Text(
                              "${vehicle.pricePerDay.toStringAsFixed(0)}k VNĐ",
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.blueAccent,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Nút đặt xe
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: vehicle.status == 'available' ? Colors.blueAccent : Colors.grey,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        elevation: 5,
                        shadowColor: Colors.blueAccent.withOpacity(0.4),
                      ),
                      onPressed: vehicle.status == 'available'
                          ? () => Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => const OrderScreen()),
                              )
                          : null,
                      child: const Text(
                        "🛵  ĐẶT XE NGAY",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}