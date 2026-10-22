class StudyTask {
  const StudyTask({
    required this.id,
    required this.examId,
    required this.title,
    required this.dueDate,
    required this.isComplete,
    this.notes,
  });

  final String id;
  final String examId;
  final String title;
  final DateTime dueDate;
  final bool isComplete;
  final String? notes;

  factory StudyTask.fromJson(Map<String, dynamic> json) {
    return StudyTask(
      id: json['id'] as String,
      examId: json['exam_id'] as String,
      title: json['title'] as String,
      dueDate: DateTime.parse(json['due_date'] as String),
      isComplete: json['is_complete'] as bool? ?? false,
      notes: json['notes'] as String?,
    );
  }
}
