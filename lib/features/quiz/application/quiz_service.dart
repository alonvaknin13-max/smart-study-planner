import '../domain/quiz_question.dart';

class QuizService {
  const QuizService();

  List<QuizQuestion> buildQuizFromTasks(List<String> tasks) {
    return tasks
        .take(5)
        .map(
          (task) => QuizQuestion(
            prompt: 'What is the primary objective of "$task"?',
            options: const [
              'Memorize definitions only',
              'Understand concepts and practice',
              'Skip to advanced sections',
              'Only watch summary videos',
            ],
            correctIndex: 1,
            explanation: 'Effective study combines concept understanding with active practice.',
          ),
        )
        .toList(growable: false);
  }
}
