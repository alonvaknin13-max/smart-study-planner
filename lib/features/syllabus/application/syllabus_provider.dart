import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/openai_syllabus_service.dart';

final syllabusServiceProvider = Provider<OpenAiSyllabusService>(
  (_) => OpenAiSyllabusService(),
);
