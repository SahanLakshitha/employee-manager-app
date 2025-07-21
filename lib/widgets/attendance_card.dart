import 'package:flutter/material.dart';
import '../models/attendance_model.dart';

class AttendanceCard extends StatelessWidget {
  final AttendanceRecord? record;

  const AttendanceCard({required this.record, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (record == null) {
      return const Padding(
        padding: EdgeInsets.all(12),
        child: Text("No attendance for today → Status: Absent"),
      );
    }

    return Card(
      margin: const EdgeInsets.all(12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Date: ${record!.date} (${record!.dayName})"),
            Text("Check-In: ${record!.checkInTime ?? '--'}"),
            Text("Check-Out: ${record!.checkOutTime ?? '--'}"),
            Text("Time Spent: ${record!.timeSpent ?? '--'}"),
            Text("Status: ${record!.status}"),
          ],
        ),
      ),
    );
  }
}
