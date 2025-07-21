class Task {
  final String id;
  final String name;
  final String dueDate; // MM/DD/YYYY
  final String priority; // Low / Medium / High
  String status; // Not Started / In Progress / Done

  Task({
    required this.id,
    required this.name,
    required this.dueDate,
    required this.priority,
    required this.status,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'dueDate': dueDate,
        'priority': priority,
        'status': status,
      };

  factory Task.fromJson(Map<String, dynamic> json) => Task(
        id: json['id'],
        name: json['name'],
        dueDate: json['dueDate'],
        priority: json['priority'],
        status: json['status'],
      );
}
