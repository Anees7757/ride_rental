class Booking {
  int? id;
  String customername;
  String customercontact;
  String date;
  int amount;
  String vnum;
  String driver;

  Booking(
      {this.id,
      required this.customername,
      required this.customercontact,
      required this.date,
      required this.amount,
      required this.vnum,
      required this.driver});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'customername': customername,
      'customercontact': customercontact,
      'date': date,
      'amount': amount,
      'vnum': vnum,
      'driver': driver,
    };
  }
}
