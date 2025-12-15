
class BookingSelection {
  final String roomId;
  final String fromTime;
  final String toTime;
  final String date;
  final int hours;

  BookingSelection({
    required this.roomId,
    required this.fromTime,
    required this.toTime,
    required this.date, 
    required this.hours,
  });

  // إضافة getter للـ timeRange
  String get timeRange => '$fromTime - $toTime';

  /// دالة حساب السعر الإجمالي
  double getTotalPrice(double pricePerHour) {
    return hours * pricePerHour;
  }

  /// دالة حساب الساعات
  static int calculateHours(
    String fromHour,
    String fromPeriod,
    String toHour,
    String toPeriod,
  ) {
    int start = _convertTo24(fromHour, fromPeriod);
    int end = _convertTo24(toHour, toPeriod);
    return end - start;
  }

  /// تحويل الوقت من AM/PM إلى 24 ساعة
  static int _convertTo24(String hour, String period) {
    int h = int.parse(hour);

    if (period == 'AM') {
      if (h == 12) return 0;
      return h;
    } else {
      if (h == 12) return 12;
      return h + 12;
    }
  }
}
