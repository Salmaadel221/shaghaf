import 'package:shagf/data/models/booking_model.dart';

class ApiService {
  // خدمة وهمية لمحاكاة استدعاءات API
  
  Future<List<BookingModel>> fetchUserBookings(String userId) async {
    // محاكاة تأخير الشبكة
    await Future.delayed(const Duration(seconds: 1));

    // بيانات وهمية
    return [
      BookingModel(
        id: '1',
        userId: userId,
        roomName: 'Meeting Room A',
        startTime: DateTime.now().subtract(const Duration(hours: 2)),
        endTime: DateTime.now().subtract(const Duration(hours: 1)),
        price: 50.0,
      ),
      BookingModel(
        id: '2',
        userId: userId,
        roomName: 'Training Hall B',
        startTime: DateTime.now().add(const Duration(hours: 3)),
        endTime: DateTime.now().add(const Duration(hours: 5)),
        price: 120.0,
      ),
    ];
  }
}
