import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../data/study_task_repository.dart';

class TasksPage extends ConsumerWidget {
  const TasksPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasks = ref.watch(studyTasksProvider);

    return tasks.when(
      data: (items) {
        if (items.isEmpty) {
          return const Center(child: Text('No study tasks generated yet.'));
        }
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: items.length,
          itemBuilder: (_, index) {
            final task = items[index];
            return Card(
              child: CheckboxListTile(
                title: Text(task.title),
                subtitle: Text('Due ${DateFormat.yMMMd().format(task.dueDate)}'),
                value: task.isComplete,
                onChanged: (value) {
                  if (value == null) {
                    return;
                  }
                  ref.read(studyTaskRepositoryProvider).markComplete(task.id, value);
                },
              ),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(child: Text('Failed to load tasks: $error')),
    );
  }
}
