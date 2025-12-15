import 'package:flutter/material.dart';

class TabSelector extends StatelessWidget {
  final String selectedTab;
  final Function(String) onTabSelected;

  const TabSelector({
    super.key,
    required this.selectedTab,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 42,
      margin: const EdgeInsets.symmetric(horizontal: 60),
      decoration: BoxDecoration(
        color: const Color(0xFF979797),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Expanded(child: _buildTab('Rooms', selectedTab == 'Rooms')),
          Expanded(child: _buildTab('Roof', selectedTab == 'Roof')),
        ],
      ),
    );
  }

  Widget _buildTab(String label, bool isSelected) {
    return GestureDetector(
      onTap: () => onTabSelected(label),
      child: Container(
        margin: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF1D4036) : const Color(0xFF979797),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 16,
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
