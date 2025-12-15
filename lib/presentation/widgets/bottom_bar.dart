
import 'package:flutter/material.dart';

class BottomBar extends StatelessWidget {
  final double totalPrice;
  final VoidCallback onCheckout;

  const BottomBar({
    super.key,
    required this.totalPrice,
    required this.onCheckout,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 76,
      decoration: const BoxDecoration(
        color: Color(0xFFF2B90C),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 21),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Total
            Text(
              'Total: ${totalPrice.toStringAsFixed(0)} LE',
              style: const TextStyle(
                fontFamily: 'Roboto',
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1D4036),
                height: 1.67,
              ),
            ),

            // زر Check out
            ElevatedButton(
              onPressed: onCheckout,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1D4036),
                foregroundColor: const Color(0xFFF2F0D9),
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 9,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                elevation: 0,
              ),
              child: const Text(
                'Check out',
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  height: 1.67,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
