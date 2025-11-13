import '../../../../core/usecases/usecase.dart';
import '../entities/task_entity.dart';
import '../repositories/task_repository.dart';

class UpdateTask implements UseCase<void, TaskEntity> {
  final TaskRepository repository;
  UpdateTask(this.repository);

  @override
  Future<void> call(TaskEntity task) async {
    await repository.updateTask(task);
  }
}
