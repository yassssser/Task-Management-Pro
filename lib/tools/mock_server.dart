import 'dart:convert';
import 'dart:io';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:shelf_cors_headers/shelf_cors_headers.dart';
import 'package:task_management_pro/core/logger/logger_service.dart';

void main() async {
  final app = Router();

  List<Map<String, dynamic>> tasks = [
    {
      'id': 1,
      'title': 'Mock Task 1',
      'description': 'This is a mock task from the local API',
      'category': 'Work',
      'priority': 'High',
      'dueDate': DateTime.now().toIso8601String(),
      'isCompleted': false,
    },
  ];

  app.get('/tasks', (Request req) {
    return Response.ok(
      jsonEncode(tasks),
      headers: {'Content-Type': 'application/json'},
    );
  });

  app.get('/tasks/<id|[0-9]+>', (Request req, String id) {
    final task = tasks.firstWhere(
      (t) => t['id'] == int.parse(id),
      orElse: () => {},
    );
    if (task.isEmpty) {
      return Response.notFound(jsonEncode({'error': 'Task not found'}));
    }
    return Response.ok(
      jsonEncode(task),
      headers: {'Content-Type': 'application/json'},
    );
  });

  app.post('/tasks', (Request req) async {
    final body = await req.readAsString();
    final data = jsonDecode(body);
    data['id'] = DateTime.now().millisecondsSinceEpoch.remainder(1 << 31);
    tasks.add(data);
    return Response.ok(
      jsonEncode(data),
      headers: {'Content-Type': 'application/json'},
    );
  });

  app.put('/tasks/<id|[0-9]+>', (Request req, String id) async {
    final body = await req.readAsString();
    final data = jsonDecode(body);
    final index = tasks.indexWhere((t) => t['id'] == int.parse(id));
    if (index == -1) {
      return Response.notFound(jsonEncode({'error': 'Task not found'}));
    }
    tasks[index] = data;
    return Response.ok(
      jsonEncode(data),
      headers: {'Content-Type': 'application/json'},
    );
  });

  app.delete('/tasks/<id|[0-9]+>', (Request req, String id) {
    tasks.removeWhere((t) => t['id'] == int.parse(id));
    return Response.ok(
      jsonEncode({'message': 'Task deleted'}),
      headers: {'Content-Type': 'application/json'},
    );
  });

  final handler = const Pipeline()
      .addMiddleware(logRequests())
      .addMiddleware(corsHeaders())
      .addHandler(app.call);

  final server = await serve(handler, InternetAddress.loopbackIPv4, 8080);
  AppLogger.i(
    '✅ Mock API running on http://${server.address.host}:${server.port}',
  );
}
