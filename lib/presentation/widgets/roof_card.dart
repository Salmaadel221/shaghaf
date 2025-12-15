
// import 'package:flutter/material.dart';
// import 'package:shagf/data/models/roof_model.dart';
// import 'package:shagf/presentation/screens/booking/booking_selection.dart';

// class RoofCard extends StatefulWidget {
//   final RoofModel roof;
//   final BookingSelection? currentBooking;
//   final Function(BookingSelection?) onBookingChanged;

//   const RoofCard({
//     super.key,
//     required this.roof,
//     this.currentBooking,
//     required this.onBookingChanged,
//   });

//   @override
//   State<RoofCard> createState() => _RoofCardState();
// }

// class _RoofCardState extends State<RoofCard> with SingleTickerProviderStateMixin {
//   bool _isExpanded = false;
//   String? _fromHour;
//   String? _toHour;
//   String _fromPeriod = 'AM';
//   String _toPeriod = 'PM';

//   final List<String> hours = List.generate(12, (index) => '${index + 1}');

//   @override
//   void initState() {
//     super.initState();
//     if (widget.currentBooking != null) {
//       _parseExistingBooking();
//     }
//   }

//   void _parseExistingBooking() {
//     // لو عايز تسترجع بيانات من الحجز الحالي
//   }

//   void _toggleExpand() {
//     setState(() {
//       _isExpanded = !_isExpanded;
//     });
//   }

//   void confirmTime() {
//     if (_fromHour == null || _toHour == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('الرجاء اختيار الوقت من والى'),
//           backgroundColor: Colors.orange,
//         ),
//       );
//       return;
//     }

//     final hours = BookingSelection.calculateHours(
//       _fromHour!,
//       _fromPeriod,
//       _toHour!,
//       _toPeriod,
//     );

//     if (hours <= 0) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('الوقت النهائي يجب أن يكون بعد وقت البداية'),
//           backgroundColor: Colors.red,
//         ),
//       );
//       return;
//     }

//     final booking = BookingSelection(
//       roomId: widget.roof.id,
//       fromTime: '$_fromHour $_fromPeriod',
//       toTime: '$_toHour $_toPeriod',
//       hours: hours,
//     );

//     widget.onBookingChanged(booking);

//     setState(() {
//       _isExpanded = false;
//     });

//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(
//           'تم الحجز: $hours ساعة - ${(hours * widget.roof.pricePerHour).toStringAsFixed(0)} LE',
//         ),
//         backgroundColor: Colors.green,
//         duration: const Duration(seconds: 2),
//       ),
//     );
//   }

//   void cancelBooking() {
//     setState(() {
//       _fromHour = null;
//       _toHour = null;
//       _fromPeriod = 'AM';
//       _toPeriod = 'PM';
//     });
//     widget.onBookingChanged(null);

//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(
//         content: Text('تم إلغاء الحجز'),
//         backgroundColor: Colors.orange,
//         duration: Duration(seconds: 1),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final hasBooking = widget.currentBooking != null;

//     return GestureDetector(
//       onTap: _toggleExpand,
//       child: AnimatedContainer(
//         duration: const Duration(milliseconds: 300),
//         curve: Curves.easeInOut,
//         margin: const EdgeInsets.only(bottom: 22),
//         decoration: BoxDecoration(
//           color: const Color(0xFF1D4036).withOpacity(0.78),
//           borderRadius: const BorderRadius.only(
//             topLeft: Radius.circular(20),
//             topRight: Radius.circular(20),
//             bottomLeft: Radius.circular(43),
//             bottomRight: Radius.circular(43),
//           ),
//           border: hasBooking ? Border.all(color: const Color(0xFFF2B90C), width: 3) : null,
//         ),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             // الصورة والعنوان
//             SizedBox(
//               height: 186,
//               child: Stack(
//                 children: [
//                   Positioned(
//                     left: 12,
//                     top: 10,
//                     child: ClipRRect(
//                       borderRadius: const BorderRadius.only(
//                         topLeft: Radius.circular(20),
//                         topRight: Radius.circular(20),
//                         bottomLeft: Radius.circular(43),
//                         bottomRight: Radius.circular(43),
//                       ),
//                       child: Image.network(
//                         widget.roof.images.isNotEmpty ? widget.roof.images[0] : "",
//                         width: 308.86,
//                         height: 149.636,
//                         fit: BoxFit.cover,
//                         errorBuilder: (context, error, stackTrace) => Container(
//                           width: 308.86,
//                           height: 149.636,
//                           color: Colors.grey[300],
//                           child: const Icon(
//                             Icons.image_not_supported,
//                             size: 50,
//                             color: Colors.grey,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),

//                   // Gradient overlay
//                   Positioned(
//                     left: 12,
//                     top: 10,
//                     child: Container(
//                       width: 308.86,
//                       height: 149.636,
//                       decoration: BoxDecoration(
//                         borderRadius: const BorderRadius.only(
//                           topLeft: Radius.circular(20),
//                           topRight: Radius.circular(20),
//                           bottomLeft: Radius.circular(43),
//                           bottomRight: Radius.circular(43),
//                         ),
//                         gradient: LinearGradient(
//                           begin: Alignment.topCenter,
//                           end: Alignment.bottomCenter,
//                           colors: [
//                             Colors.transparent,
//                             Colors.black.withOpacity(0.5),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),

//                   // العنوان
//                   Positioned(
//                     left: 45,
//                     bottom: 23,
//                     child: Text(
//                       widget.roof.nameEn,
//                       style: const TextStyle(
//                         fontFamily: 'Roboto',
//                         fontSize: 25,
//                         fontWeight: FontWeight.w400,
//                         color: Color(0xFFF0E99A),
//                       ),
//                     ),
//                   ),

//                   // السعر
//                   Positioned(
//                     left: 34,
//                     bottom: 2,
//                     child: Text(
//                       '${widget.roof.pricePerHour.toStringAsFixed(0)} LE/hour',
//                       style: const TextStyle(
//                         fontFamily: 'Roboto',
//                         fontSize: 18,
//                         fontWeight: FontWeight.w400,
//                         color: Color(0xFFF0E99A),
//                       ),
//                     ),
//                   ),

//                   // معلومات الحجز
//                   if (hasBooking)
//                     Positioned(
//                       right: 20,
//                       bottom: 10,
//                       child: Container(
//                         padding: const EdgeInsets.symmetric(
//                           horizontal: 12,
//                           vertical: 6,
//                         ),
//                         decoration: BoxDecoration(
//                           color: const Color(0xFFF2B90C),
//                           borderRadius: BorderRadius.circular(15),
//                         ),
//                         child: Text(
//                           '${widget.currentBooking!.hours}h',
//                           style: const TextStyle(
//                             fontFamily: 'Inter',
//                             fontSize: 14,
//                             fontWeight: FontWeight.bold,
//                             color: Color(0xFF1D4036),
//                           ),
//                                     ),
//                                   ),
//                                 ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 );
//               }
//             }

import 'package:flutter/material.dart';
import 'package:shagf/data/models/roof_model.dart';
import 'package:shagf/presentation/screens/booking/booking_selection.dart';

class RoofCard extends StatefulWidget {
  final RoofModel roof;
  final BookingSelection? currentBooking;
  final Function(BookingSelection?) onBookingChanged;

  const RoofCard({
    super.key,
    required this.roof,
    this.currentBooking,
    required this.onBookingChanged,
  });

  @override
  State<RoofCard> createState() => _RoofCardState();
}

class _RoofCardState extends State<RoofCard>
    with SingleTickerProviderStateMixin {
  bool _expanded = false;

  String? _fromHour;
  String? _toHour;
  String _fromPeriod = 'AM';
  String _toPeriod = 'PM';

  final List<String> hours = List.generate(12, (i) => '${i + 1}');
  final List<String> periods = ['AM', 'PM'];

  void _toggle() {
    setState(() => _expanded = !_expanded);
  }

  void _confirm() {
    if (_fromHour == null || _toHour == null) return;

    final h = BookingSelection.calculateHours(
      _fromHour!,
      _fromPeriod,
      _toHour!,
      _toPeriod,
    );

    if (h <= 0) return;

    widget.onBookingChanged(
      BookingSelection(
        roomId: widget.roof.id,
        fromTime: '$_fromHour $_fromPeriod',
        toTime: '$_toHour $_toPeriod',
        hours: h, date: '',
      ),
    );

    setState(() => _expanded = false);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggle,
      child: AnimatedSize(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
        child: Container(
          margin: const EdgeInsets.only(bottom: 24),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF395E55),
            borderRadius: BorderRadius.circular(28),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // IMAGE
              ClipRRect(
                borderRadius: BorderRadius.circular(22),
                child: Image.network(
                  widget.roof.images.isNotEmpty
                      ? widget.roof.images.first
                      : '',
                  height: 170,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),

              const SizedBox(height: 12),

              // TITLE
              Text(
                widget.roof.nameEn,
                style: const TextStyle(
                  fontSize: 22,
                  color: Color(0xFFF2E9A7),
                  fontWeight: FontWeight.w500,
                ),
              ),

              Text(
                '${widget.roof.pricePerHour.toStringAsFixed(0)} LE/hour',
                style: const TextStyle(
                  fontSize: 15,
                  color: Color(0xFFF2E9A7),
                ),
              ),

              if (_expanded) ...[
                const SizedBox(height: 20),

                _timeRow(
                  label: 'From',
                  hour: _fromHour,
                  period: _fromPeriod,
                  onHour: (v) => setState(() => _fromHour = v),
                  onPeriod: (v) => setState(() => _fromPeriod = v),
                ),

                const SizedBox(height: 12),

                _timeRow(
                  label: 'To',
                  hour: _toHour,
                  period: _toPeriod,
                  onHour: (v) => setState(() => _toHour = v),
                  onPeriod: (v) => setState(() => _toPeriod = v),
                ),

                const SizedBox(height: 18),

                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF2B90C),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                    onPressed: _confirm,
                    child: const Text(
                      'Confirm Time',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ]
            ],
          ),
        ),
      ),
    );
  }

  Widget _timeRow({
    required String label,
    required String? hour,
    required String period,
    required Function(String) onHour,
    required Function(String) onPeriod,
  }) {
    return Row(
      children: [
        SizedBox(
          width: 50,
          child: Text(
            label,
            style: const TextStyle(color: Color(0xFFF2E9A7)),
          ),
        ),
        Expanded(
          child: _dropdown(hour, hours, onHour),
        ),
        const SizedBox(width: 10),
        SizedBox(
          width: 70,
          child: _dropdown(period, periods, onPeriod),
        ),
      ],
    );
  }

  Widget _dropdown(
      String? value, List<String> items, Function(String) onChanged) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF6F857E),
        borderRadius: BorderRadius.circular(14),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          hint: const Text('Hour', style: TextStyle(color: Colors.white70)),
          isExpanded: true,
          dropdownColor: const Color(0xFF6F857E),
          items: items
              .map((e) =>
                  DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          onChanged: (v) => onChanged(v!),
        ),
      ),
    );
  }
}
