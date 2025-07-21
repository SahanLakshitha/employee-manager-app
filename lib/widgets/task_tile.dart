import 'package:flutter/material.dart';
import '../models/task_model.dart';

class TaskTile extends StatelessWidget {
  final Task task;
  final Function(String) onStatusChanged;

  const TaskTile(
      {required this.task, required this.onStatusChanged, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        title: Text(task.name),
        subtitle: Text('Due: ${task.dueDate} | Priority: ${task.priority}'),
        trailing: DropdownButton<String>(
          value: task.status,
          items: ['Not Started', 'In Progress', 'Done'].map((status) {
            return DropdownMenuItem(value: status, child: Text(status));
          }).toList(),
          onChanged: (val) {
            if (val != null) onStatusChanged(val);
          },
        ),
      ),
    );
  }
}
