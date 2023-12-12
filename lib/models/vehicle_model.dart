class Vehicle {
  int? id;
  String name;
  String vehicleNo;
  String model;
  String image;

  Vehicle(
      {this.id,
      required this.name,
      required this.model,
      required this.vehicleNo,
      required this.image});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'vehicleNo': vehicleNo,
      'model': model,
      'image': image,
    };
  }
}
