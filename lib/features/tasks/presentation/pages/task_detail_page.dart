import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:task_management_pro/features/tasks/domain/entities/task_entity.dart';
import 'package:task_management_pro/features/tasks/presentation/bloc/task_bloc.dart';
import 'package:task_management_pro/features/tasks/presentation/bloc/task_event.dart';

class TaskDetailPage extends StatelessWidget {
  final TaskEntity task;
  final TaskBloc bloc;

  const TaskDetailPage({super.key, required this.task, required this.bloc});

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'task_${task.id}',
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Task Details'),
          actions: [
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: () {
                bloc.add(DeleteTaskEvent(task.id!));
                Navigator.pop(context);
              },
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(Icons.calendar_today, size: 18),
                    const SizedBox(width: 6),
                    Text(
                      DateFormat('dd MMM yyyy').format(task.dueDate),
                      style: const TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  task.description.isNotEmpty
                      ? task.description
                      : 'No description provided.',
                  style: const TextStyle(fontSize: 16, height: 1.5),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    const Text(
                      'Status:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Chip(
                      label: Text(
                        task.isCompleted ? 'Completed' : 'In Progress',
                        style: const TextStyle(color: Colors.white),
                      ),
                      backgroundColor: task.isCompleted
                          ? Colors.green
                          : Colors.orange,
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                Align(
                  alignment: Alignment.center,
                  child: ElevatedButton.icon(
                    icon: Icon(
                      task.isCompleted
                          ? Icons.undo_rounded
                          : Icons.check_circle_outline,
                    ),
                    label: Text(
                      task.isCompleted
                          ? 'Mark as Incomplete'
                          : 'Mark as Completed',
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      textStyle: const TextStyle(fontSize: 16),
                    ),
                    onPressed: () {
                      bloc.add(
                        UpdateTaskEvent(
                          TaskEntity(
                            id: task.id,
                            title: task.title,
                            description: task.description,
                            category: task.category,
                            priority: task.priority,
                            dueDate: task.dueDate,
                            isCompleted: !task.isCompleted,
                          ),
                        ),
                      );
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
