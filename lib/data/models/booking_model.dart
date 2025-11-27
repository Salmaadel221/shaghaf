class BookingModel {
  final String id;
  final String userId;
  final String roomName;
  final DateTime startTime;
  final DateTime endTime;
  final double price;

  BookingModel({
    required this.id,
    required this.userId,
    required this.roomName,
    required this.startTime,
    required this.endTime,
    required this.price,
  });

  factory BookingModel.fromMap(Map<String, dynamic> map) {
    return BookingModel(
      id: map['id'] as String,
      userId: map['userId'] as String,
      roomName: map['roomName'] as String,
      startTime: DateTime.parse(map['startTime'] as String),
      endTime: DateTime.parse(map['endTime'] as String),
      price: map['price'] as double,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'roomName': roomName,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'price': price,
    };
  }
}
