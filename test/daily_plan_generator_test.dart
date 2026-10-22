import 'package:flutter_test/flutter_test.dart';
import 'package:smart_study_planner/features/planner/application/daily_plan_generator.dart';

void main() {
  test('generates deterministic tasks from topics', () {
    final generator = DailyPlanGenerator();
    final tasks = generator.buildPlan(
      examId: 'exam-1',
      targetDate: DateTime(2026, 12, 1),
      topics: const ['Algebra', 'Geometry', 'Calculus'],
      from: DateTime(2026, 11, 1),
    );

    expect(tasks, hasLength(3));
    expect(tasks.first.title, 'Study: Algebra');
    expect(tasks.first.examId, 'exam-1');
    expect(tasks.last.dueDate.isAfter(tasks.first.dueDate), isTrue);
  });
}
