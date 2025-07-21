import 'package:flutter/material.dart';
import 'screens/attendance_screen.dart';
import 'screens/tasks_screen.dart';
import 'screens/about_screen.dart';

void main() {
  runApp(AttendanceTasksApp());
}

class AttendanceTasksApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Attendance & Tasks',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;

  final _screens = [
    AttendanceScreen(),
    TasksScreen(),
    AboutScreen(),
  ];

  void _simulateError() {
    throw Exception("Simulated error for testing error UI.");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
          onLongPress: _simulateError,
          child: Text("Employee Manager"),
        ),
      ),
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.access_time), label: 'Attendance'),
          BottomNavigationBarItem(icon: Icon(Icons.task), label: 'Tasks'),
          BottomNavigationBarItem(icon: Icon(Icons.info), label: 'About'),
        ],
        onTap: (index) => setState(() => _currentIndex = index),
      ),
    );
  }
}
