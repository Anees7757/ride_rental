class Expense {
  int? id;
  int bookingid;
  String narration;
  int amount;

  Expense({
    this.id,
    required this.bookingid,
    required this.narration,
    required this.amount,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'bookingid': bookingid,
      'narration': narration,
      'amount': amount,
    };
  }
}
