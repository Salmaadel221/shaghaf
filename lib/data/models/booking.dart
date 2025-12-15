class Booking {
  final String bookingId;
  final String roomId;
  final String branchId;
  final String startTime;
  final String endTime;
  final double totalPrice;
  final String status;

  Booking({
    required this.bookingId,
    required this.roomId,
    required this.branchId,
    required this.startTime,
    required this.endTime,
    required this.totalPrice,
    required this.status,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      bookingId: json['bookingId'],
      roomId: json['booking']['roomId'],
      branchId: json['booking']['branchId'],
      startTime: json['booking']['startTime'],
      endTime: json['booking']['endTime'],
      totalPrice: (json['booking']['totalPrice'] ?? 0).toDouble(),
      status: json['booking']['status'],
    );
  }
}
