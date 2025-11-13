import 'package:get_it/get_it.dart';
import 'package:task_management_pro/features/tasks/data/datasources/task_local_data_source.dart';
import 'package:task_management_pro/features/tasks/data/datasources/task_remote_data_source.dart';
import 'package:task_management_pro/features/tasks/data/repositories/task_repository_impl.dart';
import 'package:task_management_pro/features/tasks/domain/repositories/task_repository.dart';
import 'package:task_management_pro/features/tasks/domain/usecases/create_task.dart';
import 'package:task_management_pro/features/tasks/domain/usecases/delete_task.dart';
import 'package:task_management_pro/features/tasks/domain/usecases/get_all_tasks.dart';
import 'package:task_management_pro/features/tasks/domain/usecases/update_task.dart';
import 'package:task_management_pro/features/tasks/presentation/bloc/task_bloc.dart';

final sl = GetIt.instance;

Future<void> setupInjector() async {
  sl.registerLazySingleton<TaskLocalDataSource>(
    () => TaskLocalDataSourceImpl(),
  );
  sl.registerLazySingleton<TaskRemoteDataSource>(() => TaskRemoteDataSource());

  sl.registerLazySingleton<TaskRepository>(
    () => TaskRepositoryImpl(localDataSource: sl(), remoteDataSource: sl()),
  );

  // ✅ Use correct use case class names
  sl.registerLazySingleton(() => GetAllTasks(sl()));
  sl.registerLazySingleton(() => CreateTask(sl()));
  sl.registerLazySingleton(() => UpdateTask(sl()));
  sl.registerLazySingleton(() => DeleteTask(sl()));

  sl.registerFactory(
    () => TaskBloc(
      getAllTasks: sl(),
      createTask: sl(),
      updateTask: sl(),
      deleteTask: sl(),
    ),
  );
}
