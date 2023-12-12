class Driver {
  int? id;
  String name;
  String? licenseNumber;
  String phoneNumber;
  String city;
  String image;

  Driver({
    this.id,
    required this.name,
    this.licenseNumber,
    required this.phoneNumber,
    required this.city,
    required this.image,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'licenseNumber': licenseNumber,
      'phoneNumber': phoneNumber,
      'city': city,
      'image': image
    };
  }
}
