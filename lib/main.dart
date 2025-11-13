import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:task_management_pro/core/di/injector.dart';
import 'package:task_management_pro/core/logger/logger_service.dart';
import 'package:task_management_pro/core/notifications/notification_service.dart';
import 'package:task_management_pro/core/theme/app_theme.dart';
import 'package:task_management_pro/core/usecases/usecase.dart';
import 'package:task_management_pro/features/tasks/domain/entities/task_entity.dart';
import 'package:task_management_pro/features/tasks/presentation/bloc/task_bloc.dart';
import 'package:task_management_pro/features/tasks/presentation/bloc/task_event.dart';
import 'package:task_management_pro/features/tasks/presentation/pages/task_detail_page.dart';
import 'package:task_management_pro/features/tasks/presentation/pages/task_list_page.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupInjector();
  AppLogger.i('🔧 App initialized - setting up notifications');
  await NotificationService.init();

  NotificationService.setOnNotificationTap((payload) async {
    if (payload != null) {
      final taskId = int.tryParse(payload);
      if (taskId != null) {
        final taskBloc = sl<TaskBloc>();

        final allTasks = await taskBloc.getAllTasks(NoParams());

        TaskEntity? task;
        for (final t in allTasks) {
          if (t.id == taskId) {
            task = t;
            break;
          }
        }

        if (task != null) {
          navigatorKey.currentState?.push(
            MaterialPageRoute(
              builder: (_) => TaskDetailPage(task: task!, bloc: taskBloc),
            ),
          );
        } else {
          debugPrint('⚠️ Task with id $taskId not found.');
        }
      }
    }
  });

  runApp(const TaskManagementProApp());
}

class TaskManagementProApp extends StatelessWidget {
  const TaskManagementProApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => GetIt.I<TaskBloc>()..add(LoadTasks())),
      ],
      child: MaterialApp(
        navigatorKey: navigatorKey,
        debugShowCheckedModeBanner: false,
        title: 'Task Management Pro',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        home: const TaskListPage(),
      ),
    );
  }
}
