import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../planner/data/study_task_repository.dart';
import '../application/quiz_service.dart';

class QuizPage extends ConsumerStatefulWidget {
  const QuizPage({super.key});

  @override
  ConsumerState<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends ConsumerState<QuizPage> {
  int? _selectedIndex;
  int _questionIndex = 0;
  int _score = 0;

  @override
  Widget build(BuildContext context) {
    final tasks = ref.watch(studyTasksProvider);

    return tasks.when(
      data: (items) {
        final questions = const QuizService().buildQuizFromTasks(
          items.map((task) => task.title).toList(growable: false),
        );

        if (questions.isEmpty) {
          return const Center(child: Text('Complete study tasks to unlock quiz questions.'));
        }

        final question = questions[_questionIndex];

        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Question ${_questionIndex + 1}/${questions.length}',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 12),
              Text(question.prompt, style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 16),
              ...List.generate(question.options.length, (index) {
                return RadioListTile<int>(
                  value: index,
                  groupValue: _selectedIndex,
                  title: Text(question.options[index]),
                  onChanged: (value) => setState(() => _selectedIndex = value),
                );
              }),
              const Spacer(),
              FilledButton(
                onPressed: _selectedIndex == null
                    ? null
                    : () {
                        final isCorrect = _selectedIndex == question.correctIndex;
                        if (isCorrect) {
                          _score += 1;
                        }

                        if (_questionIndex == questions.length - 1) {
                          showDialog<void>(
                            context: context,
                            builder: (_) => AlertDialog(
                              title: const Text('Quiz completed'),
                              content: Text('You scored $_score/${questions.length}.'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    setState(() {
                                      _questionIndex = 0;
                                      _selectedIndex = null;
                                      _score = 0;
                                    });
                                  },
                                  child: const Text('Restart'),
                                ),
                              ],
                            ),
                          );
                          return;
                        }

                        setState(() {
                          _questionIndex += 1;
                          _selectedIndex = null;
                        });
                      },
                child: const Text('Submit'),
              ),
            ],
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(child: Text('Could not load quiz: $error')),
    );
  }
}
