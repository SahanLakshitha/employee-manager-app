import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// ignore: use_key_in_widget_constructors
class AboutScreen extends StatelessWidget {
  final String yourName = 'Sahan Lakshitha';
  final String buildDate = DateFormat('yyyy/MM/dd').format(DateTime.now());

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.info_outline, size: 48, color: Colors.blueAccent),
            const SizedBox(height: 20),
            const Text('Employee Attendance & Tasks App',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            const Text('Developed by:', style: TextStyle(fontSize: 16)),
            const Text(
                'Sahan Lakshitha Wettamuni \n sahanlw17@gmail.com \n +94 71 76 95 961',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                textAlign: TextAlign.center),
            const SizedBox(height: 10),
            Text('Build Date: 21/07/2025',
                style: TextStyle(color: Colors.grey[600])),
          ],
        ),
      ),
    );
  }
}
