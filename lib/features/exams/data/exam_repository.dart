import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

import '../../auth/application/auth_controller.dart';
import '../domain/exam.dart';

abstract class ExamRepository {
  Stream<List<Exam>> watchExams();
  Future<Exam> createExam({required String title, required DateTime targetDate, String? syllabusPath});
  Future<String?> pickAndUploadSyllabus();
}

class SupabaseExamRepository implements ExamRepository {
  SupabaseExamRepository(this._client);

  final SupabaseClient _client;
  final _uuid = const Uuid();

  @override
  Stream<List<Exam>> watchExams() {
    return _client
        .from('exams')
        .stream(primaryKey: ['id'])
        .order('target_date')
        .map((rows) => rows.map(Exam.fromJson).toList());
  }

  @override
  Future<Exam> createExam({
    required String title,
    required DateTime targetDate,
    String? syllabusPath,
  }) async {
    final created = await _client
        .from('exams')
        .insert({
          'title': title,
          'target_date': targetDate.toIso8601String(),
          if (syllabusPath != null) 'syllabus_path': syllabusPath,
        })
        .select()
        .single();

    return Exam.fromJson(created);
  }

  @override
  Future<String?> pickAndUploadSyllabus() async {
    final picked = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
      withData: true,
    );

    final file = picked?.files.single;
    final bytes = file?.bytes;
    if (file == null || bytes == null) {
      return null;
    }

    final path = '${_uuid.v4()}-${file.name}';
    await _client.storage.from('syllabi').uploadBinary(
          path,
          Uint8List.fromList(bytes),
          fileOptions: const FileOptions(contentType: 'application/pdf', upsert: false),
        );
    return path;
  }
}

final examRepositoryProvider = Provider<ExamRepository>(
  (ref) => SupabaseExamRepository(ref.watch(supabaseClientProvider)),
);

final examsProvider = StreamProvider<List<Exam>>(
  (ref) => ref.watch(examRepositoryProvider).watchExams(),
);
