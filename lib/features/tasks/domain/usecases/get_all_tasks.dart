import '../../../../core/usecases/usecase.dart';
import '../entities/task_entity.dart';
import '../repositories/task_repository.dart';

class GetAllTasks implements UseCase<List<TaskEntity>, NoParams> {
  final TaskRepository repository;
  GetAllTasks(this.repository);

  @override
  Future<List<TaskEntity>> call(NoParams params) async {
    return await repository.getAllTasks();
  }
}
