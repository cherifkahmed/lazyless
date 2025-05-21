import 'package:flutter/material.dart';

class MyListTile extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;
  const MyListTile({super.key, required this.title, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      onTap: onPressed,
    );
  }
}