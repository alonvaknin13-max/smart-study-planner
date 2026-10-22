import 'package:flutter/material.dart';

import '../../auth/presentation/profile_menu_button.dart';
import '../../exams/presentation/exams_page.dart';
import '../../progress/presentation/progress_page.dart';
import '../../quiz/presentation/quiz_page.dart';
import 'tasks_page.dart';

class PlannerShell extends StatefulWidget {
  const PlannerShell({super.key});

  @override
  State<PlannerShell> createState() => _PlannerShellState();
}

class _PlannerShellState extends State<PlannerShell> {
  var _index = 0;

  static const _pages = [
    ExamsPage(),
    TasksPage(),
    QuizPage(),
    ProgressPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Smart Study Planner'),
        actions: const [ProfileMenuButton()],
      ),
      body: _pages[_index],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (value) => setState(() => _index = value),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.event_note), label: 'Exams'),
          NavigationDestination(icon: Icon(Icons.checklist), label: 'Tasks'),
          NavigationDestination(icon: Icon(Icons.quiz), label: 'Quiz'),
          NavigationDestination(icon: Icon(Icons.insights), label: 'Progress'),
        ],
      ),
    );
  }
}
