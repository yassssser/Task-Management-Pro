import '../../domain/entities/task_entity.dart';
import '../../domain/repositories/task_repository.dart';
import '../datasources/task_local_data_source.dart';
import '../datasources/task_remote_data_source.dart';
import '../models/task_model.dart';

class TaskRepositoryImpl implements TaskRepository {
  final TaskLocalDataSource localDataSource;
  final TaskRemoteDataSource remoteDataSource;

  TaskRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
  });

  @override
  Future<List<TaskEntity>> getAllTasks() async {
    try {
      final remoteTasks = await remoteDataSource.getAllTasks();
      // Update local cache
      for (var task in remoteTasks) {
        await localDataSource.upsertTask(task);
      }
      return remoteTasks;
    } catch (_) {
      // Fallback to local
      return await localDataSource.getAllTasks();
    }
  }

  @override
  Future<TaskEntity> createTask(TaskEntity task) async {
    final model = TaskModel.fromEntity(task);

    try {
      final remoteTask = await remoteDataSource.createTask(model);
      await localDataSource.upsertTask(remoteTask);
      return remoteTask;
    } catch (_) {
      // Fallback to local
      final localTask = await localDataSource.createTask(model);
      return localTask;
    }
  }

  @override
  Future<void> updateTask(TaskEntity task) async {
    final model = TaskModel.fromEntity(task);

    try {
      await remoteDataSource.updateTask(model);
      await localDataSource.upsertTask(model);
    } catch (_) {
      await localDataSource.updateTask(model);
    }
  }

  @override
  Future<void> deleteTask(int id) async {
    try {
      await remoteDataSource.deleteTask(id);
      await localDataSource.deleteTask(id);
    } catch (_) {
      await localDataSource.deleteTask(id);
    }
  }
}
