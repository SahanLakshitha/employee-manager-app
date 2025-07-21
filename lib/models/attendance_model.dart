class AttendanceRecord {
  final String date; // format: MM/DD/YYYY
  final String dayName; // Monday, Tuesday ...
  final String? checkInTime; // HH:mm
  final String? checkOutTime; // HH:mm
  final String? timeSpent; // HH:mm
  final String status; // Present / Incomplete / Absent / On Leave

  AttendanceRecord({
    required this.date,
    required this.dayName,
    this.checkInTime,
    this.checkOutTime,
    this.timeSpent,
    required this.status,
  });

  Map<String, dynamic> toJson() => {
        'date': date,
        'dayName': dayName,
        'checkInTime': checkInTime,
        'checkOutTime': checkOutTime,
        'timeSpent': timeSpent,
        'status': status,
      };

  factory AttendanceRecord.fromJson(Map<String, dynamic> json) =>
      AttendanceRecord(
        date: json['date'],
        dayName: json['dayName'],
        checkInTime: json['checkInTime'],
        checkOutTime: json['checkOutTime'],
        timeSpent: json['timeSpent'],
        status: json['status'],
      );
}
