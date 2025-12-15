import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shagf/data/models/room_model.dart';
import 'package:shagf/data/models/roof_model.dart';
import 'package:shagf/presentation/screens/booking/booking_detail_card.dart';
import 'package:shagf/presentation/screens/booking/booking_selection.dart';
import 'package:shagf/presentation/screens/payment/payment_method.dart';

class BookingOverviewScreen extends StatelessWidget {
  final List<RoomModel> rooms;
  final List<RoofModel> roofs;
  final List<BookingSelection> roomsBookings;
  final List<BookingSelection> roofsBookings;

  const BookingOverviewScreen({
    Key? key,
    required this.rooms,
    required this.roofs,
    required this.roomsBookings,
    required this.roofsBookings,
  }) : super(key: key);

  // -------- جمع كل الحجوزات --------
  List<Map<String, dynamic>> _getAllBookings() {
    final all = <Map<String, dynamic>>[];

    for (final booking in roomsBookings) {
      final room = rooms.firstWhere(
        (r) => r.id == booking.roomId,
      );

      all.add({
        'booking': booking,
        'space': room,
        'type': 'room',
      });
    }

    for (final booking in roofsBookings) {
      final roof = roofs.firstWhere(
        (r) => r.id == booking.roomId,
      );

      all.add({
        'booking': booking,
        'space': roof,
        'type': 'roof',
      });
    }

    return all;
  }

  double _getSubtotal() {
    double total = 0;

    for (final booking in roomsBookings) {
      final room = rooms.firstWhere((r) => r.id == booking.roomId);
      total += booking.getTotalPrice(room.pricePerHour);
    }

    for (final booking in roofsBookings) {
      final roof = roofs.firstWhere((r) => r.id == booking.roomId);
      total += booking.getTotalPrice(roof.pricePerHour);
    }

    return total;
  }

  int _getSpacesCount() =>
      roomsBookings.length + roofsBookings.length;

  void _confirmBooking(BuildContext context) {
    final allBookings = [
      ...roomsBookings,
      ...roofsBookings,
    ];

    Navigator.push(
  context,
  MaterialPageRoute(
    builder: (_) => PaymentMethodsScreen(
      totalAmount: _getSubtotal(),
      bookings: allBookings,
      branchId: '',
      roomIds: allBookings.map((b) => b.roomId).toList(), // ✅ الحل
    ),
  ),
);

  }

  @override
  Widget build(BuildContext context) {
    final allBookings = _getAllBookings();

    return Scaffold(
      backgroundColor: const Color(0xFF5C7363),
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(context),
              Expanded(
                child: allBookings.isEmpty
                    ? const Center(
                        child: Text(
                          'لا توجد حجوزات',
                          style: TextStyle(
                            color: Color(0xFFF2F0D9),
                            fontSize: 18,
                          ),
                        ),
                      )
                    : SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 17.5,
                          vertical: 20,
                        ),
                        child: Column(
                          children: [
                            ...allBookings.map((data) {
                              return Padding(
                                padding:
                                    const EdgeInsets.only(bottom: 20),
                                child: BookingDetailCard(
                                  booking: data['booking'],
                                  space: data['space'],
                                  type: data['type'],
                                ),
                              );
                            }),
                            const SizedBox(height: 20),
                            _buildSummaryCard(),
                            const SizedBox(height: 20),
                            _buildConfirmButton(context),
                          ],
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      height: 80,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back,
                color: Color(0xFF1D4036)),
          ),
          const SizedBox(width: 10),
          const Expanded(
            child: Text(
              'Booking Overview',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1D4036),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard() {
    final subtotal = _getSubtotal();
    final count = _getSpacesCount();

    return Container(
      width: 340,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F0D9),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          _row('Subtotal ($count spaces)', subtotal),
          const Divider(),
          _row('Total Amount', subtotal, bold: true),
        ],
      ),
    );
  }

  Widget _row(String label, double value, {bool bold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: TextStyle(
              fontWeight: bold ? FontWeight.bold : FontWeight.normal,
            )),
        Text(
          '${value.toStringAsFixed(0)} LE',
          style: TextStyle(
            fontWeight: bold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  Widget _buildConfirmButton(BuildContext context) {
    return SizedBox(
      width: 250,
      height: 50,
      child: ElevatedButton(
        onPressed: () => _confirmBooking(context),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF1D4036),
          foregroundColor: const Color(0xFFF2F0D9),
        ),
        child: const Text('Confirm Booking'),
      ),
    );
  }
}
