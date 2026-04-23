import 'package:flutter/material.dart';
import '../models/vehicle_model.dart';
import '../services/api_service.dart';
import 'vehicle_detail_screen.dart';

class VehicleScreen extends StatefulWidget {
  const VehicleScreen({super.key});

  @override
  State<VehicleScreen> createState() => _VehicleScreenState();
}

class _VehicleScreenState extends State<VehicleScreen> {
  List<Vehicle> vehicles = [];
  bool isLoading = true;
  String? errorMsg;

  @override
  void initState() {
    super.initState();
    fetchVehicles();
  }

  Future<void> fetchVehicles() async {
    setState(() {
      isLoading = true;
      errorMsg = null;
    });
    try {
      final data = await ApiService().getVehicles();
      setState(() => vehicles = data);
    } catch (e) {
      setState(() => errorMsg = "Không thể tải danh sách xe. Kiểm tra kết nối!");
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            } else {
              // Fallback if no history
              Navigator.of(context).pushReplacementNamed('/login');
            }
          },
        ),
        title: const Text("🏍️ Danh Sách Xe", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: fetchVehicles,
          )
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.black))
          : errorMsg != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.wifi_off, size: 60, color: Colors.grey),
                      const SizedBox(height: 16),
                      Text(errorMsg!, style: const TextStyle(color: Colors.grey, fontSize: 16)),
                      const SizedBox(height: 20),
                      ElevatedButton.icon(
                        onPressed: fetchVehicles,
                        icon: const Icon(Icons.refresh),
                        label: const Text("Thử lại"),
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.black, foregroundColor: Colors.white),
                      )
                    ],
                  ),
                )
              : vehicles.isEmpty
                  ? const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.directions_car_outlined, size: 80, color: Colors.grey),
                          SizedBox(height: 16),
                          Text("Chưa có xe nào sẵn sàng", style: TextStyle(color: Colors.grey, fontSize: 16)),
                        ],
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: fetchVehicles,
                      color: Colors.black,
                      child: ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: vehicles.length,
                        itemBuilder: (context, index) {
                          final v = vehicles[index];
                          return GestureDetector(
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => VehicleDetailScreen(vehicle: v)),
                            ),
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.07),
                                    blurRadius: 15,
                                    offset: const Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 70,
                                      height: 70,
                                      decoration: BoxDecoration(
                                        color: Colors.grey.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: const Icon(Icons.directions_bike, color: Colors.black, size: 40),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            v.name,
                                            style: const TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xFF2C3E50),
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            v.description.isNotEmpty ? v.description : "Xe chất lượng cao",
                                            style: const TextStyle(color: Colors.grey, fontSize: 13),
                                          ),
                                          const SizedBox(height: 8),
                                          Row(
                                            children: [
                                              Text(
                                                "${v.pricePerDay.toStringAsFixed(0)}k/ngày",
                                                style: const TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15,
                                                ),
                                              ),
                                              const Spacer(),
                                              Container(
                                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                                decoration: BoxDecoration(
                                                  color: v.status == 'available'
                                                      ? Colors.green.withOpacity(0.15)
                                                      : Colors.red.withOpacity(0.15),
                                                  borderRadius: BorderRadius.circular(20),
                                                ),
                                                child: Text(
                                                  v.status == 'available' ? "Còn xe" : "Hết xe",
                                                  style: TextStyle(
                                                    color: v.status == 'available' ? Colors.green : Colors.red,
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
    );
  }
}