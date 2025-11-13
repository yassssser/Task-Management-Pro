import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_management_pro/core/logger/logger_service.dart';
import 'package:task_management_pro/core/notifications/notification_service.dart';
import 'task_event.dart';
import 'task_state.dart';
import '../../domain/usecases/get_all_tasks.dart';
import '../../domain/usecases/create_task.dart';
import '../../domain/usecases/update_task.dart';
import '../../domain/usecases/delete_task.dart';
import '../../../../core/usecases/usecase.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final GetAllTasks getAllTasks;
  final CreateTask createTask;
  final UpdateTask updateTask;
  final DeleteTask deleteTask;

  TaskBloc({
    required this.getAllTasks,
    required this.createTask,
    required this.updateTask,
    required this.deleteTask,
  }) : super(TaskInitial()) {
    on<LoadTasks>(_onLoadTasks);
    on<AddTask>(_onAddTask);
    on<UpdateTaskEvent>(_onUpdateTask);
    on<DeleteTaskEvent>(_onDeleteTask);
  }

  Future<void> _onLoadTasks(LoadTasks event, Emitter<TaskState> emit) async {
    emit(TaskLoading());
    try {
      final result = await getAllTasks(NoParams());

      await scheduleDailyTaskSummary(const TimeOfDay(hour: 16, minute: 0));

      emit(TaskLoaded(result));
    } catch (e) {
      emit(TaskError('Failed to load tasks : ${e.toString()}'));
    }
  }

  Future<void> _onAddTask(AddTask event, Emitter<TaskState> emit) async {
    if (state is TaskLoaded) {
      try {
        AppLogger.i('Adding new task', event.task.title);
        await createTask(event.task);
        final updated = await getAllTasks(NoParams());

        final id = event.task.id;
        final scheduledId =
            (id ?? DateTime.now().millisecondsSinceEpoch) % 2147483647;
        await NotificationService.scheduleTaskNotification(
          id: scheduledId,
          title: 'Task Reminder',
          body: event.task.title,
          scheduledDate: event.task.dueDate,
        );
        AppLogger.d(
          'Task created & notification scheduled with ID $scheduledId',
        );
        emit(TaskLoaded(updated));
      } catch (e) {
        emit(TaskError('Failed to add task: ${e.toString()}'));
      }
    }
  }

  Future<void> _onUpdateTask(
    UpdateTaskEvent event,
    Emitter<TaskState> emit,
  ) async {
    if (state is TaskLoaded) {
      try {
        AppLogger.i('Updating task', event.task.title);
        await updateTask(event.task);
        final updated = await getAllTasks(NoParams());

        await NotificationService.cancelNotification(event.task.id!);

        await NotificationService.scheduleTaskNotification(
          id: event.task.id!,
          title: 'Task Reminder',
          body: event.task.title,
          scheduledDate: event.task.dueDate,
        );
        AppLogger.d('Notification rescheduled for task ${event.task.id}');
        emit(TaskLoaded(updated));
      } catch (e) {
        emit(TaskError('Failed to update task: ${e.toString()}'));
      }
    }
  }

  Future<void> _onDeleteTask(
    DeleteTaskEvent event,
    Emitter<TaskState> emit,
  ) async {
    if (state is TaskLoaded) {
      try {
        AppLogger.w('Deleting task with ID ${event.id}');
        await deleteTask(event.id);
        final updated = await getAllTasks(NoParams());
        await NotificationService.cancelNotification(event.id);
        AppLogger.d('Notification canceled for task ${event.id}');
        emit(TaskLoaded(updated));
      } catch (e) {
        emit(TaskError('Failed to delete task: ${e.toString()}'));
      }
    }
  }

  Future<void> scheduleDailyTaskSummary(TimeOfDay time) async {
    final tasks = state is TaskLoaded ? (state as TaskLoaded).tasks : [];
    final today = DateTime.now();

    final todayTasks = tasks.where(
      (t) =>
          t.dueDate.year == today.year &&
          t.dueDate.month == today.month &&
          t.dueDate.day == today.day,
    );

    final body = todayTasks.isEmpty
        ? 'You have no tasks today!'
        : 'You have ${todayTasks.length} task(s) today.';

    await NotificationService.scheduleDailySummary(
      id: 999999,
      title: 'Daily Task Summary',
      body: body,
      time: time,
    );
  }
}
