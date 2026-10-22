import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../planner/application/daily_plan_generator.dart';
import '../../planner/data/study_task_repository.dart';
import '../../syllabus/application/syllabus_provider.dart';
import '../data/exam_repository.dart';
import '../domain/exam.dart';

class ExamsPage extends ConsumerWidget {
  const ExamsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final exams = ref.watch(examsProvider);

    return Scaffold(
      body: exams.when(
        data: (items) {
          if (items.isEmpty) {
            return const Center(child: Text('No exams yet. Add your first exam.'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: items.length,
            itemBuilder: (_, index) => _ExamCard(exam: items[index]),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Failed to load exams: $error')),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showCreateExamDialog(context, ref),
        icon: const Icon(Icons.add),
        label: const Text('Add Exam'),
      ),
    );
  }

  Future<void> _showCreateExamDialog(BuildContext context, WidgetRef ref) async {
    final titleController = TextEditingController();
    DateTime targetDate = DateTime.now().add(const Duration(days: 14));
    String? syllabusPath;

    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setState) => AlertDialog(
            title: const Text('Create exam'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: titleController,
                    decoration: const InputDecoration(labelText: 'Exam title'),
                  ),
                  const SizedBox(height: 12),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text('Target date: ${DateFormat.yMMMd().format(targetDate)}'),
                    trailing: const Icon(Icons.calendar_today),
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 3650)),
                        initialDate: targetDate,
                      );
                      if (picked != null) {
                        setState(() => targetDate = picked);
                      }
                    },
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton.icon(
                    onPressed: () async {
                      final path = await ref.read(examRepositoryProvider).pickAndUploadSyllabus();
                      if (path != null && context.mounted) {
                        setState(() => syllabusPath = path);
                      }
                    },
                    icon: const Icon(Icons.picture_as_pdf),
                    label: Text(syllabusPath == null ? 'Upload syllabus PDF' : 'PDF uploaded'),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(),
                child: const Text('Cancel'),
              ),
              FilledButton(
                onPressed: () async {
                  if (titleController.text.trim().isEmpty) {
                    return;
                  }

                  final exam = await ref.read(examRepositoryProvider).createExam(
                        title: titleController.text.trim(),
                        targetDate: targetDate,
                        syllabusPath: syllabusPath,
                      );

                  if (syllabusPath != null) {
                    final topics = await ref
                        .read(syllabusServiceProvider)
                        .extractTopicsFromSyllabusText('Syllabus stored at path: $syllabusPath');

                    final generated = const DailyPlanGenerator().buildPlan(
                      examId: exam.id,
                      targetDate: exam.targetDate,
                      topics: topics,
                    );
                    await ref.read(studyTaskRepositoryProvider).createGeneratedTasks(generated);
                  }

                  if (dialogContext.mounted) {
                    Navigator.of(dialogContext).pop();
                  }
                },
                child: const Text('Create'),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ExamCard extends StatelessWidget {
  const _ExamCard({required this.exam});

  final Exam exam;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(exam.title),
        subtitle: Text('Target: ${DateFormat.yMMMd().format(exam.targetDate)}'),
        trailing: exam.syllabusPath == null ? null : const Icon(Icons.picture_as_pdf),
      ),
    );
  }
}
