import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/api_service.dart';
import '../models/vehicle_model.dart';
import 'vehicle_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService apiService = ApiService();
  late Future<List<Vehicle>> futureVehicles;

  @override
  void initState() {
    super.initState();
    futureVehicles = apiService.getVehicles();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                // Header: Logo, Name, Notification
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.black, width: 2),
                          ),
                          child: const Center(
                            child: Text("R", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          "RideNow",
                          style: GoogleFonts.roboto(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    Stack(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF3F4F6),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.notifications_none, color: Colors.black),
                        ),
                        Positioned(
                          right: 0,
                          top: 0,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(color: Colors.black, shape: BoxShape.circle),
                            child: const Text("2", style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 25),

                // Search Bar
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 52,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF3F4F6),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFE5E7EB)),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Row(
                          children: [
                            const Icon(Icons.search, color: Colors.grey),
                            const SizedBox(width: 10),
                            Text("Search your car want...", style: GoogleFonts.roboto(color: Colors.grey, fontSize: 14)),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Container(
                      height: 52,
                      width: 52,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.tune, color: Colors.white),
                    ),
                  ],
                ),
                const SizedBox(height: 30),

                // Brands Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Brands", style: GoogleFonts.roboto(fontSize: 18, fontWeight: FontWeight.bold)),
                    Text("View All", style: GoogleFonts.roboto(fontSize: 12, color: Colors.grey)),
                  ],
                ),
                const SizedBox(height: 15),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildBrandItem("Toyota", Icons.directions_car),
                      _buildBrandItem("Lamborghini", Icons.flash_on),
                      _buildBrandItem("BMW", Icons.brightness_high),
                      _buildBrandItem("Ferrari", Icons.speed),
                    ],
                  ),
                ),
                const SizedBox(height: 30),

                // Best Cars Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Best Cars", style: GoogleFonts.roboto(fontSize: 18, fontWeight: FontWeight.bold)),
                    Text("View All", style: GoogleFonts.roboto(fontSize: 12, color: Colors.grey)),
                  ],
                ),
                const SizedBox(height: 15),
                FutureBuilder<List<Vehicle>>(
                  future: futureVehicles,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator(color: Colors.black));
                    }
                    if (snapshot.hasError || !snapshot.hasData) {
                      return const Center(child: Text("Error loading cars"));
                    }
                    final vehicles = snapshot.data!;
                    return GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.75,
                        crossAxisSpacing: 15,
                        mainAxisSpacing: 15,
                      ),
                      itemCount: vehicles.length > 4 ? 4 : vehicles.length,
                      itemBuilder: (context, index) {
                        return _buildCarCard(vehicles[index]);
                      },
                    );
                  },
                ),
                const SizedBox(height: 30),

                // Nearby Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Nearby", style: GoogleFonts.roboto(fontSize: 18, fontWeight: FontWeight.bold)),
                    Text("View All", style: GoogleFonts.roboto(fontSize: 12, color: Colors.grey)),
                  ],
                ),
                const SizedBox(height: 15),
                Container(
                  height: 120,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3F4F6),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Center(
                    child: Icon(Icons.map_outlined, color: Colors.black.withOpacity(0.1), size: 50),
                  ),
                ),
                const SizedBox(height: 100), // Space for bottom nav
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildBrandItem(String name, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(right: 25),
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: const Color(0xFFF3F4F6),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.black, size: 30),
          ),
          const SizedBox(height: 8),
          Text(name, style: GoogleFonts.roboto(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildCarCard(Vehicle car) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => VehicleDetailScreen(vehicle: car))),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFF9FAFB),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: const Color(0xFFE5E7EB)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                children: [
                  Center(child: Icon(Icons.directions_car, size: 60, color: Colors.black.withOpacity(0.2))),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                      child: const Icon(Icons.favorite_border, size: 16, color: Colors.black),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(car.name, style: GoogleFonts.roboto(fontWeight: FontWeight.bold, fontSize: 14)),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.black, size: 14),
                      const SizedBox(width: 4),
                      Text("5.0", style: GoogleFonts.roboto(fontSize: 12, color: Colors.grey)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("${car.pricePerDay.toStringAsFixed(0)}k/Day", style: GoogleFonts.roboto(fontWeight: FontWeight.bold, fontSize: 14)),
                      const Icon(Icons.arrow_forward_ios, size: 12, color: Colors.grey),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      height: 80,
      margin: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 10))],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildNavItem(Icons.home_filled, true),
          _buildNavItem(Icons.search, false),
          _buildNavItem(Icons.directions_car, false),
          _buildNavItem(Icons.person_outline, false),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, bool isActive) {
    return Icon(icon, color: isActive ? Colors.white : Colors.white.withOpacity(0.5), size: 28);
  }
}