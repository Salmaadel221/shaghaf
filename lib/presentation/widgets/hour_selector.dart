import 'package:flutter/material.dart';

class HourSelector extends StatelessWidget {
  final String hour;
  final bool isSelected;
  final VoidCallback onTap;

  const HourSelector({
    Key? key,
    required this.hour,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 70,
        height: 34,
        margin: const EdgeInsets.only(right: 8, bottom: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF1D4036) : const Color(0xFFF2F0D9),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFF1D4036), width: 1),
        ),
        child: Center(
          child: Text(
            hour,
            style: TextStyle(
              fontFamily: 'Roboto',
              fontSize: 14,
              color: isSelected
                  ? const Color(0xFFF2F0D9)
                  : const Color(0xFF1D4036),
            ),
          ),
        ),
      ),
    );
  }
}
