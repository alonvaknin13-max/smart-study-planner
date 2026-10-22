class QuizQuestion {
  const QuizQuestion({
    required this.prompt,
    required this.options,
    required this.correctIndex,
    required this.explanation,
  });

  final String prompt;
  final List<String> options;
  final int correctIndex;
  final String explanation;
}
