

import 'package:flutter/material.dart';
import 'package:shagf/presentation/screens/booking/booking_selection.dart';


class BookingDetailCard extends StatelessWidget {
  final BookingSelection booking;
  final dynamic space;
  final String type; // 'room' or 'roof'

  const BookingDetailCard({
    Key? key,
    required this.booking,
required this.space,
    required this.type,
  }) : super(key: key);

  // توليد Booking ID عشوائي (في الواقع يجي من الـ backend)
  String _generateBookingId() {
    final random = DateTime.now().millisecondsSinceEpoch;
    return '#${random.toString().substring(7)}';
  }

  @override
  Widget build(BuildContext context) {
    final totalPrice = booking.getTotalPrice(space.pricePerHour);

    return Column(
      children: [
        // Booking ID Header
        Container(
          height: 70,
          width: 340,
          decoration: BoxDecoration(
            color: const Color(0xFF1D4036),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const Text(
                'Booking  ID',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 20,
                  color: Color(0xFFF2F0D9),
                ),
              ),
              Text(
                _generateBookingId(),
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 15,
                  color: Color(0xFFF2F0D9),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 4),

        // Card Content
        Container(
          width: 340,
          decoration: BoxDecoration(
            color: const Color(0xFFF2F0D9),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              // Header مع اسم الغرفة/السطح والفرع
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          space.nameEn,
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 20,
                            color: Color(0xFF1D4036),
                          ),
                        ),
                        Row(
                          children: const [
                            Icon(
                              Icons.location_on,
                              color: Color(0xFF1D4036),
                              size: 16,
                            ),
                            SizedBox(width: 4),
                            Text(
                              'Maadi Branch',
                              style: TextStyle(
                                fontFamily: 'Roboto',
                                fontSize: 12,
                                color: Color(0xFF1D4036),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Container(height: 1, color: const Color(0xFF1D4036)),
                  ],
                ),
              ),

              // التفاصيل
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    // Date
                    _buildDetailRow(
                      icon: Icons.calendar_today_outlined,
                      title: 'Date',
                      value: _getCurrentDate(),
                    ),
                    const SizedBox(height: 20),

                    // Time
                    _buildDetailRow(
                      icon: Icons.access_time,
                      title: 'Time',
                      value: booking.timeRange,
                    ),
                    const SizedBox(height: 20),

                    // Capacity
                    _buildDetailRow(
                      icon: Icons.person_outline,
                      title: 'Capacity',
                      value: type == 'room' ? 'Up to 10 people' : '4 people',
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // خط فاصل
              Container(height: 1, width: 306, color: const Color(0xFF1D4036)),

              const SizedBox(height: 16),

              // Price
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 34),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'price',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 16,
                        color: Color(0xFF1D4036),
                      ),
                    ),
                    Text(
                      '\$${totalPrice.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 18,
                        color: Color(0xFF1D4036),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: const Color(0xFF1D4036), size: 24),
        const SizedBox(width: 19),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 20,
                  color: Color(0xFF1D4036),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 15,
                  color: Color(0xFF1D4036),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // دالة للحصول على التاريخ الحالي بصيغة مناسبة
  String _getCurrentDate() {
    final now = DateTime.now();
    final months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];

    return '${months[now.month - 1]} ${now.day}, ${now.year}';
  }
}
