import 'package:flutter/material.dart';

class PlaceholderScreen extends StatelessWidget {
  final String title;
  const PlaceholderScreen({required this.title, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.construction, size: 64, color: Color(0xFF9E9E9E)),
            SizedBox(height: 12),
            Text('Coming Soon', style: TextStyle(fontSize: 18, color: Color(0xFF757575))),
          ],
        ),
      ),
    );
  }
}
