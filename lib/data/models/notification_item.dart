import 'package:flutter/material.dart';

class NotificationItem {
  final String id;
  final IconData icon;
  final String title;
  final String time;
  final bool isToday;

  NotificationItem({
    required this.id,
    required this.icon,
    required this.title,
    required this.time,
    required this.isToday,
  });

  // نختار أيقونة تقريبية حسب الرسالة
  static IconData _iconFromMessage(String message) {
    final lower = message.toLowerCase();

    if (lower.contains('booking')) {
      return Icons.event_available;
    } else if (lower.contains('payment') || lower.contains('pay')) {
      return Icons.payment;
    } else if (lower.contains('warning') || lower.contains('pending')) {
      return Icons.warning_amber;
    } else if (lower.contains('event')) {
      return Icons.event;
    } else {
      return Icons.notifications_none;
    }
  }

  factory NotificationItem.fromJson(Map<String, dynamic> json) {
    final message = (json['message'] ?? '').toString();

    // هنا مفيش وقت في الـ example، فهنسيبه فاضي أو "Just now"
    final time = (json['time'] ?? 'Just now').toString();

    return NotificationItem(
      id: (json['notification_id'] ?? '').toString(),
      icon: _iconFromMessage(message),
      title: message,
      time: time,
      // بما إن مفيش تاريخ في الـ response، هنعتبر كله Today
      isToday: true,
    );
  }
}
