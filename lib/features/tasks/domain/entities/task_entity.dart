import 'package:equatable/equatable.dart';

class TaskEntity extends Equatable {
  final int? id;
  final String title;
  final String description;
  final String category;
  final String priority;
  final DateTime dueDate;
  final bool isCompleted;

  const TaskEntity({
    this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.priority,
    required this.dueDate,
    required this.isCompleted,
  });

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    category,
    priority,
    dueDate,
    isCompleted,
  ];
}
