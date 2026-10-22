class Exam {
  const Exam({
    required this.id,
    required this.userId,
    required this.title,
    required this.targetDate,
    this.syllabusPath,
    this.createdAt,
  });

  final String id;
  final String userId;
  final String title;
  final DateTime targetDate;
  final String? syllabusPath;
  final DateTime? createdAt;

  factory Exam.fromJson(Map<String, dynamic> json) {
    return Exam(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      title: json['title'] as String,
      targetDate: DateTime.parse(json['target_date'] as String),
      syllabusPath: json['syllabus_path'] as String?,
      createdAt:
          json['created_at'] == null ? null : DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toInsertJson() {
    return {
      'title': title,
      'target_date': targetDate.toIso8601String(),
      if (syllabusPath != null) 'syllabus_path': syllabusPath,
    };
  }
}
