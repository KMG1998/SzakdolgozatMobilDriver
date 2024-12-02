class Vehicle {
  final int seats;
  final String color;
  final String plateNumber;
  final String type;

  Vehicle({
    required this.seats,
    required this.color,
    required this.plateNumber,
    required this.type,
  });

  Vehicle.fromJson(Map<String, dynamic> json)
      : seats = json["seats"] as int,
        color = json["color"] as String,
        plateNumber = json["plateNumber"] as String,
        type = json["type"] as String;
}
