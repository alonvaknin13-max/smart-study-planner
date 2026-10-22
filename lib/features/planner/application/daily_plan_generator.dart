class DailyPlanGenerator {
  const DailyPlanGenerator();

  List<GeneratedTask> buildPlan({
    required String examId,
    required DateTime targetDate,
    required List<String> topics,
    DateTime? from,
  }) {
    if (topics.isEmpty) {
      return const [];
    }

    final start = DateTime(from?.year ?? DateTime.now().year, from?.month ?? DateTime.now().month,
        from?.day ?? DateTime.now().day);
    final examDay = DateTime(targetDate.year, targetDate.month, targetDate.day);
    final totalDays = examDay.difference(start).inDays;
    final spacing = totalDays <= 0 ? 1 : (totalDays ~/ topics.length).clamp(1, totalDays);

    return [
      for (var i = 0; i < topics.length; i++)
        GeneratedTask(
          examId: examId,
          title: 'Study: ${topics[i]}',
          dueDate: start.add(Duration(days: i * spacing)),
          notes: 'Focus on core concepts and solve practice questions.',
        ),
    ];
  }
}

class GeneratedTask {
  const GeneratedTask({
    required this.examId,
    required this.title,
    required this.dueDate,
    required this.notes,
  });

  final String examId;
  final String title;
  final DateTime dueDate;
  final String notes;
}
