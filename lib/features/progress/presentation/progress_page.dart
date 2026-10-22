import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../planner/data/study_task_repository.dart';

class ProgressPage extends ConsumerWidget {
  const ProgressPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasks = ref.watch(studyTasksProvider);

    return tasks.when(
      data: (items) {
        final total = items.length;
        final completed = items.where((task) => task.isComplete).length;
        final ratio = total == 0 ? 0.0 : completed / total;

        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Progress', style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 12),
              Text('$completed of $total tasks completed'),
              const SizedBox(height: 12),
              LinearProgressIndicator(value: ratio),
              const SizedBox(height: 24),
              Expanded(
                child: ListView(
                  children: [
                    _ProgressTile(
                      title: 'Completion rate',
                      value: '${(ratio * 100).toStringAsFixed(1)}%',
                    ),
                    _ProgressTile(
                      title: 'Pending tasks',
                      value: '${total - completed}',
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(child: Text('Failed to compute progress: $error')),
    );
  }
}

class _ProgressTile extends StatelessWidget {
  const _ProgressTile({required this.title, required this.value});

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(title),
        trailing: Text(
          value,
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),
    );
  }
}
