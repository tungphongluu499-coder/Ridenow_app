class Vehicle {
  final int id;
  final String name;
  final double pricePerDay;
  final String status;
  final String description;

  Vehicle({
    required this.id,
    required this.name,
    required this.pricePerDay,
    required this.status,
    required this.description,
  });

  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(
      id: json['vehicleID'],
      name: json['vehicleName'] ?? 'Không rõ',
      pricePerDay: double.parse((json['pricePerDay'] ?? 0).toString()),
      status: json['veStatus'] ?? 'available',
      description: json['veDescription'] ?? '',
    );
  }
}