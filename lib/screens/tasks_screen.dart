import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import '../models/task_model.dart';
import '../services/storage_service.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  List<Task> _tasks = [];
  bool _isLoading = true;
  String _error = '';

  final _uuid = const Uuid();

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    try {
      _tasks = await StorageService.getTasks();
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to load tasks.';
        _isLoading = false;
      });
    }
  }

  Future<void> _saveTasks() async {
    try {
      await StorageService.saveTasks(_tasks);
    } catch (e) {
      setState(() {
        _error = 'Failed to save, please try again.';
      });
    }
  }

  void _addTaskDialog() {
    final nameCtrl = TextEditingController();
    String priority = 'Medium';
    String status = 'Not Started';
    DateTime? selectedDate;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('New Task'),
        content: StatefulBuilder(
          builder: (context, setModalState) {
            return SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                      controller: nameCtrl,
                      decoration:
                          const InputDecoration(labelText: 'Task Name')),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    child: Text(selectedDate == null
                        ? 'Pick Due Date'
                        : DateFormat('MM/dd/yyyy').format(selectedDate!)),
                    onPressed: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2100),
                      );
                      if (picked != null) {
                        setModalState(() => selectedDate = picked);
                      }
                    },
                  ),
                  const SizedBox(height: 10),
                  DropdownButton<String>(
                    value: priority,
                    items: ['Low', 'Medium', 'High'].map((p) {
                      return DropdownMenuItem(value: p, child: Text(p));
                    }).toList(),
                    onChanged: (val) => setModalState(() => priority = val!),
                  ),
                  DropdownButton<String>(
                    value: status,
                    items: ['Not Started', 'In Progress', 'Done'].map((s) {
                      return DropdownMenuItem(value: s, child: Text(s));
                    }).toList(),
                    onChanged: (val) => setModalState(() => status = val!),
                  ),
                ],
              ),
            );
          },
        ),
        actions: [
          TextButton(
            child: const Text('Cancel'),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            child: const Text('Add'),
            onPressed: () {
              if (nameCtrl.text.trim().isNotEmpty && selectedDate != null) {
                final task = Task(
                  id: _uuid.v4(),
                  name: nameCtrl.text.trim(),
                  dueDate: DateFormat('MM/dd/yyyy').format(selectedDate!),
                  priority: priority,
                  status: status,
                );
                setState(() => _tasks.add(task));
                _saveTasks();
                Navigator.pop(context);
              }
            },
          ),
        ],
      ),
    );
  }

  void _updateStatus(Task task, String newStatus) {
    setState(() {
      final index = _tasks.indexWhere((t) => t.id == task.id);
      _tasks[index].status = newStatus;
    });
    _saveTasks();
  }

  Widget _buildTaskCard(Task task) {
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
          onChanged: (val) => _updateStatus(task, val!),
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
        Expanded(
          child: _tasks.isEmpty
              ? const Center(child: Text('No tasks yet'))
              : ListView(children: _tasks.map(_buildTaskCard).toList()),
        ),
        Padding(
          padding: const EdgeInsets.all(12),
          child: ElevatedButton.icon(
            icon: const Icon(Icons.add),
            label: const Text('Add Task'),
            onPressed: _addTaskDialog,
          ),
        ),
      ],
    );
  }
}
