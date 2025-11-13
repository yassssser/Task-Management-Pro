import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_management_pro/core/di/injector.dart';
import 'package:task_management_pro/features/tasks/presentation/bloc/task_bloc.dart';
import 'package:task_management_pro/features/tasks/presentation/bloc/task_event.dart';
import 'package:task_management_pro/features/tasks/presentation/bloc/task_state.dart';
import 'package:task_management_pro/features/tasks/presentation/pages/widgets/empty_state.dart';
import 'package:task_management_pro/features/tasks/presentation/pages/widgets/task_card.dart';
import 'package:task_management_pro/features/tasks/presentation/pages/widgets/task_card_animation_wrapper.dart';
import 'package:task_management_pro/features/tasks/presentation/pages/widgets/task_card_shimmer.dart';

import 'add_task_page.dart';

class TaskListPage extends StatefulWidget {
  const TaskListPage({super.key});

  @override
  State<TaskListPage> createState() => _TaskListPageState();
}

class _TaskListPageState extends State<TaskListPage> {
  late TaskBloc bloc;

  @override
  void initState() {
    super.initState();
    bloc = sl<TaskBloc>();
    bloc.add(LoadTasks());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => bloc,
      child: Scaffold(
        appBar: AppBar(title: const Text('My Tasks')),
        floatingActionButton: TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: 1),
          duration: const Duration(milliseconds: 500),
          curve: Curves.elasticOut,
          builder: (context, value, child) =>
              Transform.scale(scale: value, child: child),
          child: FloatingActionButton.extended(
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => AddTaskPage(bloc: bloc)),
              );
            },
            label: const Text('Add Task'),
            icon: const Icon(Icons.add_rounded),
          ),
        ),
        body: BlocBuilder<TaskBloc, TaskState>(
          builder: (context, state) {
            if (state is TaskLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is TaskLoaded) {
              if (state.tasks.isEmpty) {
                return const Center(child: Text('No tasks yet.'));
              }
              return RefreshIndicator(
                onRefresh: () async => bloc.add(LoadTasks()),
                child: Builder(
                  builder: (context) {
                    final state = bloc.state;
                    if (state is TaskLoading) {
                      return ListView.builder(
                        itemCount: 5,
                        itemBuilder: (_, __) => const TaskCardShimmer(),
                      );
                    } else if (state is TaskLoaded) {
                      if (state.tasks.isEmpty) {
                        return const EmptyState(
                          message:
                              'No tasks found.\nCreate your first task now!',
                        );
                      }
                      return ListView.builder(
                        itemCount: state.tasks.length,
                        itemBuilder: (context, index) {
                          final task = state.tasks[index];

                          return TaskCardAnimationWrapper(
                            index: index,
                            child: Dismissible(
                              key: ValueKey(task.id),
                              direction: DismissDirection.endToStart,
                              background: Container(
                                color: Colors.red,
                                alignment: Alignment.centerRight,
                                padding: const EdgeInsets.only(right: 20),
                                child: const Icon(
                                  Icons.delete,
                                  color: Colors.white,
                                ),
                              ),
                              onDismissed: (_) {
                                bloc.add(DeleteTaskEvent(task.id!));
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Task "${task.title}" deleted',
                                    ),
                                    duration: const Duration(seconds: 2),
                                  ),
                                );
                              },
                              child: Hero(
                                tag: 'task_${task.id}',
                                child: TaskCard(
                                  task: task,
                                  bloc: bloc,
                                  index: task.id!,
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    } else if (state is TaskError) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.error_outline,
                              size: 64,
                              color: Colors.red,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              state.message,
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 18),
                            ),
                            const SizedBox(height: 12),
                            ElevatedButton(
                              onPressed: () => bloc.add(LoadTasks()),
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      );
                    } else {
                      return const SizedBox.shrink();
                    }
                  },
                ),
              );
            } else if (state is TaskError) {
              return Center(child: Text(state.message));
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}
