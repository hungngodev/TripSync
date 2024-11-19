import 'package:http/http.dart' as http;
import 'api_key.dart';
import 'gpt_request.dart';
import 'gpt_response.dart';

class GPTService {
  static final Uri chatUri =
      Uri.parse('https://api.openai.com/v1/chat/completions');

  static final Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer ${ApiKey.openAIApiKey}',
  };

  Future<String?> request(String prompt) async {
    try {
      GPTRequest request = GPTRequest(
          model: "gpt-3.5-turbo",
          maxTokens: 150,
          messages: [Message(role: "system", content: prompt)]);
      if (prompt.isEmpty) {
        return null;
      }
      http.Response response = await http.post(
        chatUri,
        headers: headers,
        body: request.toJson(),
      );
      GPTResponse chatResponse = GPTResponse.fromResponse(response);
      return chatResponse.choices?[0].message?.content;
    } catch (e) {
      print("error $e");
    }
    return null;
  }
}
