import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final Widget child;
  // 1. جعل onPressed اختيارياً (nullable) بإضافة '?'
  final VoidCallback? onPressed;

  const CustomButton({
    Key? key,
    required this.child,
    required this.onPressed, required String text,
    // 2. تم حذف الجزء الزائد 'required Widget' من هنا
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: child,
    );
  }
}
