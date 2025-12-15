

import 'package:flutter/material.dart';
import 'package:shagf/data/models/room_model.dart';
import 'package:shagf/presentation/screens/booking/booking_selection.dart';


class RoomCard extends StatefulWidget {
  final RoomModel room;
  final BookingSelection? currentBooking;
  final Function(BookingSelection?) onBookingChanged;

  const RoomCard({
    super.key,
    required this.room,
    this.currentBooking,
    required this.onBookingChanged,
  });

  @override
  State<RoomCard> createState() => _RoomCardState();
}

class _RoomCardState extends State<RoomCard>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
  String? _fromHour;
  String? _toHour;
  String _fromPeriod = 'AM';
  String _toPeriod = 'PM';

  final List<String> _hours = List.generate(12, (index) => '${index + 1}');

  @override
  void initState() {
    super.initState();
    if (widget.currentBooking != null) {
      _parseExistingBooking();
    }
  }

  void _parseExistingBooking() {
    // لو عايزة ترجعي البيانات من الحجز القديم اكتبيه هنا
  }

  void _toggleExpand() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  void _confirmTime() {
    if (_fromHour == null || _toHour == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('الرجاء اختيار الوقت من والى'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    final hours = BookingSelection.calculateHours(
      _fromHour!, // عملت له ! لأنه String? لكن احنا متأكدين مش null
      _fromPeriod,
      _toHour!,
      _toPeriod,
    );

    if (hours <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('الوقت النهائي يجب أن يكون بعد وقت البداية'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // إنشاء الحجز
    final booking = BookingSelection(
      roomId: widget.room.id,
      fromTime: '$_fromHour $_fromPeriod',
      toTime: '$_toHour $_toPeriod',
      hours: hours, date: '',
    );

    widget.onBookingChanged(booking);

    setState(() {
      _isExpanded = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'تم الحجز: $hours ساعة - ${(hours * widget.room.pricePerHour).toStringAsFixed(0)} LE',
        ),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _cancelBooking() {
    setState(() {
      _fromHour = null;
      _toHour = null;
      _fromPeriod = 'AM';
      _toPeriod = 'PM';
    });
    widget.onBookingChanged(null);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('تم إلغاء الحجز'),
        backgroundColor: Colors.orange,
        duration: Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasBooking = widget.currentBooking != null;

    return GestureDetector(
      onTap: _toggleExpand,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        margin: const EdgeInsets.only(bottom: 22),
        decoration: BoxDecoration(
          color: const Color(0xFF1D4036).withOpacity(0.78),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
            bottomLeft: Radius.circular(43),
            bottomRight: Radius.circular(43),
          ),
          border: hasBooking
              ? Border.all(color: const Color(0xFFF2B90C), width: 3)
              : null,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ---- صورة الغرفة ----
            SizedBox(
              height: 186,
              child: Stack(
                children: [
                  Positioned(
                    left: 12,
                    top: 10,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                        bottomLeft: Radius.circular(43),
                        bottomRight: Radius.circular(43),
                      ),
                      child: widget.room.images.isNotEmpty
                          ? Image.network(
                              widget.room.images[0],
                              width: 308.86,
                              height: 149.636,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  Container(
                                    width: 308.86,
                                    height: 149.636,
                                    color: Colors.grey[300],
                                    child: const Icon(
                                      Icons.image_not_supported,
                                      size: 50,
                                      color: Colors.grey,
                                    ),
                                  ),
                            )
                          : Container(
                              width: 308.86,
                              height: 149.636,
                              color: Colors.grey[300],
                              child: const Icon(
                                Icons.image_not_supported,
                                size: 50,
                                color: Colors.grey,
                              ),
                            ),
                    ),
                  ),

                  // Gradient
                  Positioned(
                    left: 12,
                    top: 10,
                    child: Container(
                      width: 308.86,
                      height: 149.636,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                          bottomLeft: Radius.circular(43),
                          bottomRight: Radius.circular(43),
                        ),
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.5),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // ---- عنوان الغرفة ----
                  Positioned(
                    left: 45,
                    bottom: 23,
                    child: Text(
                      widget.room.nameEn,
                      style: const TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFFF0E99A),
                      ),
                    ),
                  ),

                  // ---- السعر ----
                  Positioned(
                    left: 34,
                    bottom: 2,
                    child: Text(
                      '${widget.room.pricePerHour.toStringAsFixed(0)} LE/hour',
                      style: const TextStyle(
                        fontSize: 18,
                        color: Color(0xFFF0E99A),
                      ),
                    ),
                  ),

                  // ---- عدد الساعات لو في حجز ----
                  if (hasBooking)
                    Positioned(
                      right: 20,
                      bottom: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF2B90C),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Text(
                          '${widget.currentBooking!.hours}h',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1D4036),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // ---- الجزء المتحرك ----
            AnimatedSize(
              duration: const Duration(milliseconds: 800),
              curve: Curves.easeInOut,
              child: _isExpanded
                  ? Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 20,
                      ),
                      child: Column(
                        children: [
                          _buildTimeRow(
                            label: 'From',
                            hour: _fromHour,
                            period: _fromPeriod,
                            onHourChanged: (v) => setState(() => _fromHour = v),
                            onPeriodChanged: (v) =>
                                setState(() => _fromPeriod = v!),
                          ),
                          const SizedBox(height: 15),
                          _buildTimeRow(
                            label: 'To',
                            hour: _toHour,
                            period: _toPeriod,
                            onHourChanged: (v) => setState(() => _toHour = v),
                            onPeriodChanged: (v) =>
                                setState(() => _toPeriod = v!),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              if (hasBooking)
                                Expanded(
                                  child: SizedBox(
                                    height: 45,
                                    child: ElevatedButton(
                                      onPressed: _cancelBooking,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.red.withOpacity(
                                          0.8,
                                        ),
                                        foregroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            15,
                                          ),
                                        ),
                                      ),
                                      child: const Text(
                                        'Cancel',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              if (hasBooking) const SizedBox(width: 10),
                              Expanded(
                                child: SizedBox(
                                  height: 45,
                                  child: ElevatedButton(
                                    onPressed: _confirmTime,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFFF2B90C),
                                      foregroundColor: const Color(0xFF1D4036),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                    ),
                                    child: const Text(
                                      'Confirm Time',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeRow({
    required String label,
    required String? hour,
    required String period,
    required ValueChanged<String?> onHourChanged,
    required ValueChanged<String?> onPeriodChanged,
  }) {
    return Row(
      children: [
        SizedBox(
          width: 70,
          child: Text(
            label,
            style: const TextStyle(fontSize: 18, color: Color(0xFFF0E99A)),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _buildTimeDropdown(
            value: hour,
            items: _hours,
            hint: 'Hour',
            onChanged: onHourChanged,
          ),
        ),
        const SizedBox(width: 10),
        SizedBox(
          width: 80,
          child: _buildPeriodDropdown(
            value: period,
            onChanged: onPeriodChanged,
          ),
        ),
      ],
    );
  }

  Widget _buildPeriodDropdown({
    required String value,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.3)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          dropdownColor: const Color(0xFF1D4036),
          items: ['AM', 'PM'].map((item) {
            return DropdownMenuItem(
              value: item,
              child: Text(
                item,
                style: const TextStyle(color: Color(0xFFF0E99A)),
              ),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildTimeDropdown({
    required String? value,
    required List<String> items,
    required String hint,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.3)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          dropdownColor: const Color(0xFF1D4036),
          hint: Text(
            hint,
            style: TextStyle(color: Colors.white.withOpacity(0.6)),
          ),
          items: items.map((item) {
            return DropdownMenuItem(
              value: item,
              child: Text(
                item,
                style: const TextStyle(color: Color(0xFFF0E99A)),
              ),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
