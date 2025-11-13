import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/task_model.dart';

abstract class TaskLocalDataSource {
  Future<List<TaskModel>> getAllTasks();
  Future<TaskModel> createTask(TaskModel task);
  Future<void> updateTask(TaskModel task);
  Future<void> deleteTask(int id);
  Future<void> upsertTask(TaskModel task);
}

class TaskLocalDataSourceImpl implements TaskLocalDataSource {
  static const _tableName = 'tasks';
  Database? _db;

  Future<Database> get database async {
    _db ??= await _initDB();
    return _db!;
  }

  Future<Database> _initDB() async {
    final path = join(await getDatabasesPath(), 'task_management.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $_tableName(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT,
            description TEXT,
            category TEXT,
            priority INTEGER,
            dueDate TEXT,
            isCompleted INTEGER
          )
        ''');
      },
    );
  }

  @override
  Future<void> upsertTask(TaskModel task) async {
    final db = await database;
    await db.insert(
      _tableName,
      task.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<List<TaskModel>> getAllTasks() async {
    final db = await database;
    final result = await db.query(_tableName);
    return result.map((e) => TaskModel.fromMap(e)).toList();
  }

  @override
  Future<TaskModel> createTask(TaskModel task) async {
    final db = await database;
    final id = await db.insert(_tableName, task.toMap());
    return TaskModel(
      id: id,
      title: task.title,
      description: task.description,
      category: task.category,
      priority: task.priority,
      dueDate: task.dueDate,
      isCompleted: task.isCompleted,
    );
  }

  @override
  Future<void> updateTask(TaskModel task) async {
    final db = await database;
    await db.update(
      _tableName,
      task.toMap(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  @override
  Future<void> deleteTask(int id) async {
    final db = await database;
    await db.delete(_tableName, where: 'id = ?', whereArgs: [id]);
  }
}
