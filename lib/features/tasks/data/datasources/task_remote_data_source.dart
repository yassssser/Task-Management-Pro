import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:task_management_pro/features/tasks/data/models/task_model.dart';

class TaskRemoteDataSource {
  final String baseUrl = 'http://127.0.0.1:8080';

  Future<List<TaskModel>> getAllTasks() async {
    final response = await http.get(Uri.parse('$baseUrl/tasks'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List;
      return data.map((t) => TaskModel.fromMap(t)).toList();
    } else {
      throw Exception('Failed to fetch tasks');
    }
  }

  Future<TaskModel> createTask(TaskModel task) async {
    final response = await http.post(
      Uri.parse('$baseUrl/tasks'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(task.toMap()),
    );
    if (response.statusCode == 200) {
      return TaskModel.fromMap(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create task');
    }
  }

  Future<TaskModel> updateTask(TaskModel task) async {
    final response = await http.put(
      Uri.parse('$baseUrl/tasks/${task.id}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(task.toMap()),
    );
    if (response.statusCode == 200) {
      return TaskModel.fromMap(jsonDecode(response.body));
    } else {
      throw Exception('Failed to update task');
    }
  }

  Future<void> deleteTask(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/tasks/$id'));
    if (response.statusCode != 200) {
      throw Exception('Failed to delete task');
    }
  }
}
