import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiKey {
  static String get openAIApiKey {
    return dotenv.env['OPENAI_API_KEY'] ?? 'default-api-key';
  }
}
