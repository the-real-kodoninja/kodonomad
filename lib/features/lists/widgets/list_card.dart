import 'package:flutter/material.dart';

class ListCard extends StatelessWidget {
  final Map<String, dynamic> list;
  final VoidCallback onTap;

  const ListCard({required this.list, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        title: Text(list['name']),
        subtitle: Text('Created by: ${list['profiles']['username']}'),
        trailing: const Icon(Icons.arrow_forward),
        onTap: onTap,
      ),
    );
  }
}
