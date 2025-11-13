import '../../domain/entities/task_entity.dart';

class TaskModel extends TaskEntity {
  const TaskModel({
    int? id,
    required String title,
    required String description,
    required String category,
    required String priority,
    required DateTime dueDate,
    required bool isCompleted,
  }) : super(
         id: id,
         title: title,
         description: description,
         category: category,
         priority: priority,
         dueDate: dueDate,
         isCompleted: isCompleted,
       );

  Map<String, dynamic> toMap() {
    final map = {
      'title': title,
      'description': description,
      'category': category,
      'priority': priority,
      'dueDate': dueDate.toIso8601String(),
      'isCompleted': isCompleted ? 1 : 0,
    };
    if (id != null) map['id'] = id as Object;
    return map;
  }

  factory TaskModel.fromMap(Map<String, dynamic> map) {
    return TaskModel(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      category: map['category'],
      priority: map['priority'],
      dueDate: DateTime.parse(map['dueDate']),
      isCompleted: map['isCompleted'] == 1,
    );
  }

  factory TaskModel.fromEntity(TaskEntity entity) {
    return TaskModel(
      id: entity.id,
      title: entity.title,
      description: entity.description,
      category: entity.category,
      priority: entity.priority,
      dueDate: entity.dueDate,
      isCompleted: entity.isCompleted,
    );
  }
}
