import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/view/home_screen.dart';

class NotificationScreen extends StatelessWidget {
  final List<NotificationItem> notifications = [
    NotificationItem(
        title: 'Notification 1',
        body: 'This is the body of notification 1',
        time: 'a few seconds ago',
        icon: Icons.notifications,
        backgroundColor: Colors.blue.shade100,
        iconColor: Colors.blue),
    NotificationItem(
        title: 'Notification 2',
        body: 'This is the body of notification 2',
        time: 'a few seconds ago',
        icon: Icons.notifications,
        backgroundColor: Colors.blue.shade100,
        iconColor: Colors.blue),
    NotificationItem(
        title: 'Notification 3',
        body: 'This is the body of notification 3',
        time: 'a few seconds ago',
        icon: Icons.notifications,
        backgroundColor: Colors.blue.shade100,
        iconColor: Colors.blue),
    NotificationItem(
        title: 'Notification 4',
        body: 'This is the body of notification 4',
        time: 'a few seconds ago',
        icon: Icons.notifications,
        backgroundColor: Colors.blue.shade100,
        iconColor: Colors.blue),
    NotificationItem(
        title: 'Notification 5',
        body: 'This is the body of notification 5',
        time: 'a few seconds ago',
        icon: Icons.notifications_active_outlined,
        backgroundColor: Colors.white,
        iconColor: Colors.black),
    NotificationItem(
        title: 'Notification 6',
        body: 'This is the body of notification 6',
        time: 'a few seconds ago',
        icon: Icons.notifications_active_outlined,
        backgroundColor: Colors.white,
        iconColor: Colors.black),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        

        title: Text('Thông báo', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.blue, // Thay đổi màu nền AppBar ở đây
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.black), // Thay đổi màu icon
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: notifications.length,
          itemBuilder: (context, index) {
            return NotificationCard(item: notifications[index]);
          },
        ),
      ),
    );
  }
}

class NotificationItem {
  final String title;
  final String body;
  final String time;
  final IconData icon;
  final Color backgroundColor;
  final Color iconColor;

  NotificationItem({
    required this.title,
    required this.body,
    required this.time,
    required this.icon,
    required this.backgroundColor,
    required this.iconColor,
  });
}

class NotificationCard extends StatelessWidget {
  final NotificationItem item;

  const NotificationCard({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: item.backgroundColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 5,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: item.iconColor.withOpacity(0.1),
            child: Icon(item.icon, color: item.iconColor),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                SizedBox(height: 4),
                Text(
                  item.body,
                  style: TextStyle(color: Colors.black54),
                ),
                SizedBox(height: 4),
                Text(
                  item.time,
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}



