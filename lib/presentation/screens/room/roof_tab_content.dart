
import 'package:flutter/material.dart';
import 'package:shagf/data/models/roof_model.dart';
import 'package:shagf/presentation/screens/booking/booking_selection.dart';
import 'package:shagf/presentation/widgets/roof_card.dart';


class RoofTabContent extends StatefulWidget {
  final List<RoofModel> roofs;
  final Function(List<BookingSelection>) onBookingsChanged;

  const RoofTabContent({
    super.key,
    required this.roofs,
    required this.onBookingsChanged,
  });

  @override
  State<RoofTabContent> createState() => _RoofTabContentState();
}

class _RoofTabContentState extends State<RoofTabContent> {
  // Map to store bookings for each roof
  final Map<String, BookingSelection> _bookings = {};

  void _handleBookingChanged(String roofId, BookingSelection? booking) {
    setState(() {
      if (booking == null) {
        _bookings.remove(roofId);
      } else {
        _bookings[roofId] = booking;
      }
    });

    // Notify parent with updated bookings
    widget.onBookingsChanged(_bookings.values.toList());
  }

  @override
  Widget build(BuildContext context) {
    if (widget.roofs.isEmpty) {
      return const Center(
        child: Text(
          'لا توجد أسطح متاحة',
          style: TextStyle(color: Color(0xFFF2F0D9), fontSize: 18),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.only(
        left: 25.5,
        right: 25.5,
        top: 10,
        bottom: 100,
      ),
      itemCount: widget.roofs.length,
      itemBuilder: (context, index) {
        final roof = widget.roofs[index];
        final currentBooking = _bookings[roof.id];

        return RoofCard(
          key: ValueKey('roof-${roof.id}'),
          roof: roof,
          currentBooking: currentBooking,
          onBookingChanged: (booking) =>
              _handleBookingChanged(roof.id, booking),
        );
      },
    );
  }
}
