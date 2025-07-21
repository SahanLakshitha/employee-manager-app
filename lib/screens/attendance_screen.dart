import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/attendance_model.dart';
import '../services/storage_service.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  String? _name;
  bool _isLoading = true;
  String _error = '';
  AttendanceRecord? _todayRecord;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      _name = await StorageService.getUserName();
      _todayRecord = await StorageService.getTodayAttendance();

      // Delay dialog display until UI is built
      if (_name == null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _showNameDialog();
        });
      }

      setState(() => _isLoading = false);
    } catch (e) {
      setState(() {
        _error = 'Failed to load data.';
        _isLoading = false;
      });
    }
  }

  void _showNameDialog() {
    final controller = TextEditingController();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: const Text('Enter Your Name'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: 'Your Name'),
        ),
        actions: [
          ElevatedButton(
            child: const Text('Save'),
            onPressed: () async {
              final name = controller.text.trim();
              if (name.isNotEmpty) {
                await StorageService.setUserName(name);
                setState(() => _name = name);
                Navigator.pop(context);
              }
            },
          ),
        ],
      ),
    );
  }

  Future<void> _saveRecord(AttendanceRecord record) async {
    try {
      await StorageService.saveTodayAttendance(record);
    } catch (e) {
      setState(() {
        _error = 'Failed to save, please try again.';
      });
    }
  }

  void _onCheckIn() async {
    final now = DateTime.now();
    final date = DateFormat('MM/dd/yyyy').format(now);
    final dayName = DateFormat('EEEE').format(now);
    final checkInTime = DateFormat('HH:mm').format(now);

    final newRecord = AttendanceRecord(
      date: date,
      dayName: dayName,
      checkInTime: checkInTime,
      checkOutTime: null,
      timeSpent: null,
      status: 'Incomplete',
    );

    await _saveRecord(newRecord);
    setState(() => _todayRecord = newRecord);
  }

  void _onCheckOut() async {
    if (_todayRecord?.checkInTime == null) return;

    final now = DateTime.now();
    final checkOutTime = DateFormat('HH:mm').format(now);

    final checkInParts = _todayRecord!.checkInTime!.split(':');
    final checkIn = DateTime(
      now.year,
      now.month,
      now.day,
      int.parse(checkInParts[0]),
      int.parse(checkInParts[1]),
    );

    final duration = now.difference(checkIn);
    final timeSpent =
        '${duration.inHours.toString().padLeft(2, '0')}:${(duration.inMinutes % 60).toString().padLeft(2, '0')}';

    final newRecord = AttendanceRecord(
      date: _todayRecord!.date,
      dayName: _todayRecord!.dayName,
      checkInTime: _todayRecord!.checkInTime,
      checkOutTime: checkOutTime,
      timeSpent: timeSpent,
      status: 'Present',
    );

    await _saveRecord(newRecord);
    setState(() => _todayRecord = newRecord);
  }

  Widget _buildRecordCard() {
    if (_todayRecord == null) {
      return const Text("No attendance for today → Status: Absent");
    }

    return Card(
      margin: const EdgeInsets.all(12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Date: ${_todayRecord!.date} (${_todayRecord!.dayName})"),
            Text("Check-In: ${_todayRecord!.checkInTime ?? '--'}"),
            Text("Check-Out: ${_todayRecord!.checkOutTime ?? '--'}"),
            Text("Time Spent: ${_todayRecord!.timeSpent ?? '--'}"),
            Text("Status: ${_todayRecord!.status}"),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return const Center(child: CircularProgressIndicator());

    if (_error.isNotEmpty) {
      return Center(
          child: Text(_error, style: const TextStyle(color: Colors.red)));
    }

    return Column(
      children: [
        if (_name != null)
          Padding(
            padding: const EdgeInsets.all(12),
            child:
                Text("Welcome, $_name", style: const TextStyle(fontSize: 18)),
          ),
        _buildRecordCard(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
                onPressed: _onCheckIn, child: const Text('Check In')),
            ElevatedButton(
                onPressed: _onCheckOut, child: const Text('Check Out')),
          ],
        ),
      ],
    );
  }
}
