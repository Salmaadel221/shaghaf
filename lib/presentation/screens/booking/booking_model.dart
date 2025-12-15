
class BookingModel {
  final String id;
  final String bookingId;
  final String type; // 'room' أو 'roof'
  final String name; // مثل "ROOM 1" أو "Rooftop Terrace"
  final String branch;
  final String date;
  final String timeFrom;
  final String timeTo;
  final int hours;
  final int capacity;
  final double price;

  BookingModel({
    required this.id,
    required this.bookingId,
    required this.type,
    required this.name,
    required this.branch,
    required this.date,
    required this.timeFrom,
    required this.timeTo,
    required this.hours,
    required this.capacity,
    required this.price,
  });

  // تحويل من JSON
  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      id: json['id'] ?? '',
      bookingId: json['booking_id'] ?? '',
      type: json['type'] ?? 'room',
      name: json['name'] ?? '',
      branch: json['branch'] ?? '',
      date: json['date'] ?? '',
      timeFrom: json['time_from'] ?? '',
      timeTo: json['time_to'] ?? '',
      hours: json['hours'] ?? 0,
      capacity: json['capacity'] ?? 0,
      price: (json['price'] ?? 0.0).toDouble(),
    );
  }

  // تحويل إلى JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'booking_id': bookingId,
      'type': type,
      'name': name,
      'branch': branch,
      'date': date,
      'time_from': timeFrom,
      'time_to': timeTo,
      'hours': hours,
      'capacity': capacity,
      'price': price,
    };
  }

  // النص الخاص بالوقت
  String get timeRange => '$timeFrom - $timeTo ($hours hours)';

  // النص الخاص بالسعة
  String get capacityText {
    if (type == 'room') {
      return 'Up to $capacity people';
    } else {
      return '$capacity people';
    }
  }
}
