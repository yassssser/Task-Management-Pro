import '../../../../core/usecases/usecase.dart';
import '../repositories/task_repository.dart';

class DeleteTask implements UseCase<void, int> {
  final TaskRepository repository;
  DeleteTask(this.repository);

  @override
  Future<void> call(int id) async {
    await repository.deleteTask(id);
  }
}
