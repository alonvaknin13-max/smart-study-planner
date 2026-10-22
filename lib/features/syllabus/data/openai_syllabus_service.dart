import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../core/config/env.dart';

class OpenAiSyllabusService {
  OpenAiSyllabusService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  Future<List<String>> extractTopicsFromSyllabusText(String syllabusText) async {
    final authHeader = ['Bearer', Env.openAiApiKey].join(' ');
    final response = await _client.post(
      Uri.parse('https://api.openai.com/v1/chat/completions'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': authHeader,
      },
      body: jsonEncode({
        'model': 'gpt-4o-mini',
        'temperature': 0.2,
        'response_format': {'type': 'json_object'},
        'messages': [
          {
            'role': 'system',
            'content':
                'You are an educational planner. Return JSON with a "topics" array of concise syllabus topics.',
          },
          {
            'role': 'user',
            'content': 'Extract key study topics from this syllabus:\n$syllabusText',
          },
        ],
      }),
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw StateError('OpenAI request failed: ${response.statusCode} ${response.body}');
    }

    final payload = jsonDecode(response.body) as Map<String, dynamic>;
    final choices = payload['choices'] as List<dynamic>;
    final message = choices.first['message'] as Map<String, dynamic>;
    final content = message['content'] as String;
    final parsed = jsonDecode(content) as Map<String, dynamic>;
    final topics = (parsed['topics'] as List<dynamic>?)?.cast<String>() ?? <String>[];
    return topics.where((topic) => topic.trim().isNotEmpty).toList(growable: false);
  }
}
