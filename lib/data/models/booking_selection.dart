class BookingSelection {
  final String roomId;
  final String fromTime;
  final String toTime;
  final int hours;

  BookingSelection({
    required this.roomId,
    required this.fromTime,
    required this.toTime,
    required this.hours,
  });

  String get timeRange => '$fromTime - $toTime';

  double getTotalPrice(double pricePerHour) {
    return hours * pricePerHour;
  }

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
