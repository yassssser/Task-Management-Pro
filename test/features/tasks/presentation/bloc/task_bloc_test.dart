import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:task_management_pro/features/tasks/domain/usecases/create_task.dart';

import 'package:task_management_pro/features/tasks/presentation/bloc/task_bloc.dart';
import 'package:task_management_pro/features/tasks/presentation/bloc/task_event.dart';
import 'package:task_management_pro/features/tasks/presentation/bloc/task_state.dart';
import 'package:task_management_pro/features/tasks/domain/entities/task_entity.dart';
import 'package:task_management_pro/features/tasks/domain/usecases/get_all_tasks.dart';

import 'package:task_management_pro/features/tasks/domain/usecases/update_task.dart';
import 'package:task_management_pro/features/tasks/domain/usecases/delete_task.dart';

// Mocks
class MockGetAllTasks extends Mock implements GetAllTasks {}

class MockAddTask extends Mock implements CreateTask {}

class MockUpdateTask extends Mock implements UpdateTask {}

class MockDeleteTask extends Mock implements DeleteTask {}

class FakeTaskEntity extends Fake implements TaskEntity {}

void main() {
  late MockGetAllTasks mockGetAllTasks;
  late MockAddTask mockAddTask;
  late MockUpdateTask mockUpdateTask;
  late MockDeleteTask mockDeleteTask;
  late TaskBloc bloc;
  late TaskEntity testTask;

  setUpAll(() {
    registerFallbackValue(FakeTaskEntity());
  });

  setUp(() {
    mockGetAllTasks = MockGetAllTasks();
    mockAddTask = MockAddTask();
    mockUpdateTask = MockUpdateTask();
    mockDeleteTask = MockDeleteTask();

    bloc = TaskBloc(
      getAllTasks: mockGetAllTasks,
      createTask: mockAddTask,
      updateTask: mockUpdateTask,
      deleteTask: mockDeleteTask,
    );

    testTask = TaskEntity(
      id: 1,
      title: 'Test Task',
      description: 'Unit test task',
      dueDate: DateTime.now().add(const Duration(days: 1)),
      category: 'Work',
      priority: 'High',
      isCompleted: false,
    );
  });

  tearDown(() => bloc.close());

  group('TaskBloc', () {
    blocTest<TaskBloc, TaskState>(
      'emits [TaskLoading, TaskLoaded] when LoadTasks succeeds',
      build: () {
        when(() => mockGetAllTasks(any())).thenAnswer((_) async => [testTask]);
        return bloc;
      },
      act: (bloc) => bloc.add(LoadTasks()),
      expect: () => [
        isA<TaskLoading>(),
        isA<TaskLoaded>()
            .having((s) => s.tasks.length, 'length', 1)
            .having((s) => s.tasks.first.title, 'title', 'Test Task'),
      ],
      verify: (_) {
        verify(() => mockGetAllTasks(any())).called(1);
      },
    );

    blocTest<TaskBloc, TaskState>(
      'emits [TaskLoaded] when AddTask succeeds',
      build: () {
        when(() => mockAddTask(any())).thenAnswer((_) async => testTask);
        when(() => mockGetAllTasks(any())).thenAnswer((_) async => [testTask]);
        return bloc..emit(TaskLoaded([]));
      },
      act: (bloc) => bloc.add(AddTask(testTask)),
      expect: () => [
        isA<TaskLoaded>().having((s) => s.tasks.length, 'length', 1),
      ],
      verify: (_) {
        verify(() => mockAddTask(any())).called(1);
        verify(() => mockGetAllTasks(any())).called(1);
      },
    );

    blocTest<TaskBloc, TaskState>(
      'emits [TaskLoaded] when UpdateTaskEvent succeeds',
      build: () {
        when(() => mockUpdateTask(any())).thenAnswer((_) async => {});
        when(() => mockGetAllTasks(any())).thenAnswer((_) async => [testTask]);
        return bloc..emit(TaskLoaded([testTask]));
      },
      act: (bloc) => bloc.add(UpdateTaskEvent(testTask)),
      expect: () => [
        isA<TaskLoaded>().having((s) => s.tasks.length, 'length', 1),
      ],
      verify: (_) {
        verify(() => mockUpdateTask(any())).called(1);
        verify(() => mockGetAllTasks(any())).called(1);
      },
    );

    blocTest<TaskBloc, TaskState>(
      'emits [TaskLoaded] when DeleteTaskEvent succeeds',
      build: () {
        when(() => mockDeleteTask(any())).thenAnswer((_) async => {});
        when(() => mockGetAllTasks(any())).thenAnswer((_) async => []);
        return bloc..emit(TaskLoaded([testTask]));
      },
      act: (bloc) => bloc.add(DeleteTaskEvent(testTask.id!)),
      expect: () => [
        isA<TaskLoaded>().having((s) => s.tasks.isEmpty, 'isEmpty', true),
      ],
      verify: (_) {
        verify(() => mockDeleteTask(any())).called(1);
        verify(() => mockGetAllTasks(any())).called(1);
      },
    );

    blocTest<TaskBloc, TaskState>(
      'emits [TaskError] when AddTask throws',
      build: () {
        when(() => mockAddTask(any())).thenThrow(Exception('Failed to add'));
        return bloc..emit(TaskLoaded([]));
      },
      act: (bloc) => bloc.add(AddTask(testTask)),
      expect: () => [isA<TaskError>()],
    );
  });
}
