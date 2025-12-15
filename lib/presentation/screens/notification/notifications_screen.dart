import 'package:flutter/material.dart';
import 'package:shagf/data/models/notification_item.dart';
import 'package:shagf/presentation/widgets/notification_card.dart';

class NotificationScreen extends StatelessWidget {
  final List<NotificationItem> notifications;
  final VoidCallback onClearAll;

   NotificationScreen({
    Key? key,
    required this.notifications,
    required this.onClearAll,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final todayNotifications =
        notifications.where((n) => n.isToday).toList();
    final olderNotifications =
        notifications.where((n) => !n.isToday).toList();

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        
        title: const Text(
          'Notification',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (todayNotifications.isNotEmpty) ...[
              const Text(
                'TODAY',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 12),
              ...todayNotifications.map(
                (notification) =>
                    NotificationCard(notification: notification),
              ),
            ],
            if (olderNotifications.isNotEmpty) ...[
              const SizedBox(height: 20),
              const Text(
                'Older',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 12),
              ...olderNotifications.map(
                (notification) =>
                    NotificationCard(notification: notification),
              ),
            ],
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: onClearAll,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade400,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 12,
                  ),
                ),
                child: const Text(
                  'Clear All Notifications',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
