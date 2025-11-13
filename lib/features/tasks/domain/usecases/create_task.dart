import '../../../../core/usecases/usecase.dart';
import '../entities/task_entity.dart';
import '../repositories/task_repository.dart';

class CreateTask implements UseCase<TaskEntity, TaskEntity> {
  final TaskRepository repository;
  CreateTask(this.repository);

  @override
  Future<TaskEntity> call(TaskEntity task) async {
    return await repository.createTask(task);
  }
}
