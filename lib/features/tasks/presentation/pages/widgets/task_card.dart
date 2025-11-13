import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:task_management_pro/features/tasks/domain/entities/task_entity.dart';
import 'package:task_management_pro/features/tasks/presentation/bloc/task_bloc.dart';
import 'package:task_management_pro/features/tasks/presentation/bloc/task_event.dart';
import 'package:task_management_pro/features/tasks/presentation/pages/edit_task_page.dart';
import 'package:task_management_pro/features/tasks/presentation/pages/task_detail_page.dart';

class TaskCard extends StatelessWidget {
  final TaskEntity task;
  final TaskBloc bloc;
  final int index;

  const TaskCard({
    super.key,
    required this.task,
    required this.bloc,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 300 + index * 100),
      builder: (context, value, child) => Opacity(
        opacity: value,
        child: Transform.translate(
          offset: Offset(0, 50 * (1 - value)),
          child: child,
        ),
      ),
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: ListTile(
          title: Text(
            task.title,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              decoration: task.isCompleted ? TextDecoration.lineThrough : null,
            ),
          ),
          subtitle: Text(
            DateFormat('dd MMM yyyy').format(task.dueDate),
            style: const TextStyle(color: Colors.grey),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Checkbox(
                value: task.isCompleted,
                onChanged: (_) => bloc.add(
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
                ),
              ),
              const SizedBox(width: 8),
              // Edit Icon
              IconButton(
                icon: const Icon(Icons.edit_rounded),
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => EditTaskPage(task: task, bloc: bloc),
                    ),
                  );
                },
              ),
            ],
          ),

          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => TaskDetailPage(task: task, bloc: bloc),
            ),
          ),
        ),
      ),
    );
  }
}
