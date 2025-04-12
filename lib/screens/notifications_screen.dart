import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/notification_provider.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifications = ref.watch(notificationProvider);
    return Scaffold(
      appBar: AppBar(title: Text('Notifications')),
      body: ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final notif = notifications[index];
          return ListTile(
            title: Text(notif['content']),
            subtitle: Text(notif['timestamp'].toString().substring(0, 16)),
            leading: Icon(notif['type'] == 'like' ? Icons.favorite : Icons.person_add),
            tileColor: notif['is_read'] ? null : Colors.grey[200],
          );
        },
      ),
    );
  }
}
