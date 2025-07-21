import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'dart:convert';

import '../models/attendance_model.dart';
import '../models/task_model.dart';

class StorageService {
  static Future<SharedPreferences> get _prefs async =>
      await SharedPreferences.getInstance();

  /// ---------------- Attendance ---------------- ///

  static String get todayKey =>
      "attendance_${DateFormat('MM/dd/yyyy').format(DateTime.now())}";

  static Future<String?> getUserName() async {
    final prefs = await _prefs;
    return prefs.getString('employee_name');
  }

  static Future<void> setUserName(String name) async {
    final prefs = await _prefs;
    await prefs.setString('employee_name', name);
  }

  static Future<AttendanceRecord?> getTodayAttendance() async {
    final prefs = await _prefs;
    final data = prefs.getString(todayKey);
    if (data == null) return null;
    return AttendanceRecord.fromJson(jsonDecode(data));
  }

  static Future<void> saveTodayAttendance(AttendanceRecord record) async {
    final prefs = await _prefs;
    await prefs.setString(todayKey, jsonEncode(record.toJson()));
  }

  /// ---------------- Tasks ----------------  ///

  static Future<List<Task>> getTasks() async {
    final prefs = await _prefs;
    final list = prefs.getStringList('tasks') ?? [];
    return list.map((e) => Task.fromJson(jsonDecode(e))).toList();
  }

  static Future<void> saveTasks(List<Task> tasks) async {
    final prefs = await _prefs;
    final encoded = tasks.map((task) => jsonEncode(task.toJson())).toList();
    await prefs.setStringList('tasks', encoded);
  }
}
