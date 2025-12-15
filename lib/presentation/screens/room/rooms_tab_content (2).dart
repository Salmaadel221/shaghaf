
import 'package:flutter/material.dart';
import 'package:shagf/data/models/room_model.dart';
import 'package:shagf/presentation/screens/booking/booking_selection.dart';
import 'package:shagf/presentation/widgets/room_card.dart';


class RoomsTabContent extends StatefulWidget {
  final List<RoomModel> rooms;
  final Function(List<BookingSelection>) onBookingsChanged;

  const RoomsTabContent({
    super.key,
    required this.rooms,
    required this.onBookingsChanged,
  });

  @override
  State<RoomsTabContent> createState() => _RoomsTabContentState();
}

class _RoomsTabContentState extends State<RoomsTabContent> {
  // Map to store bookings for each room
  final Map<String, BookingSelection> _bookings = {};

  void _handleBookingChanged(String roomId, BookingSelection? booking) {
    setState(() {
      if (booking == null) {
        _bookings.remove(roomId);
      } else {
        _bookings[roomId] = booking;
      }

      widget.onBookingsChanged(_bookings.values.toList());
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.rooms.isEmpty) {
      return const Center(
        child: Text(
          'لا توجد غرف متاحة',
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
      itemCount: widget.rooms.length,
      itemBuilder: (context, index) {
        final room = widget.rooms[index];
        final currentBooking = _bookings[room.id];

        return RoomCard(
          key: ValueKey('room-${room.id}'),
          room: room,
          currentBooking: currentBooking,
          onBookingChanged: (booking) =>
              _handleBookingChanged(room.id, booking),
        );
      },
    );
  }
}
