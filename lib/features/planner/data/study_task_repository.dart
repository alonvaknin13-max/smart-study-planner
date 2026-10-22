import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../auth/application/auth_controller.dart';
import '../application/daily_plan_generator.dart';
import '../domain/study_task.dart';

abstract class StudyTaskRepository {
  Stream<List<StudyTask>> watchTasks();
  Future<void> createGeneratedTasks(List<GeneratedTask> tasks);
  Future<void> markComplete(String id, bool isComplete);
}

class SupabaseStudyTaskRepository implements StudyTaskRepository {
  SupabaseStudyTaskRepository(this._client);

  final SupabaseClient _client;

  @override
  Stream<List<StudyTask>> watchTasks() {
    return _client
        .from('study_tasks')
        .stream(primaryKey: ['id'])
        .order('due_date')
        .map((rows) => rows.map(StudyTask.fromJson).toList());
  }

  @override
  Future<void> createGeneratedTasks(List<GeneratedTask> tasks) async {
    if (tasks.isEmpty) {
      return;
    }

    await _client.from('study_tasks').insert([
      for (final task in tasks)
        {
          'exam_id': task.examId,
          'title': task.title,
          'due_date': task.dueDate.toIso8601String(),
          'notes': task.notes,
          'is_complete': false,
        },
    ]);
  }

  @override
  Future<void> markComplete(String id, bool isComplete) {
    return _client.from('study_tasks').update({'is_complete': isComplete}).eq('id', id);
  }
}

final studyTaskRepositoryProvider = Provider<StudyTaskRepository>(
  (ref) => SupabaseStudyTaskRepository(ref.watch(supabaseClientProvider)),
);

final studyTasksProvider = StreamProvider<List<StudyTask>>(
  (ref) => ref.watch(studyTaskRepositoryProvider).watchTasks(),
);
