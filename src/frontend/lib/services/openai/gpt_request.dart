import 'dart:convert';

class GPTRequest {
  final String model;
  final List<Message> messages;
  final int? maxTokens;

  GPTRequest({
    required this.model,
    required this.messages,
    this.maxTokens,
  });

  String toJson() {
    Map<String, dynamic> jsonBody = {
      'model': model,
      'messages': List<Map<String, dynamic>>.from(messages.map((message) => message.toJson())),
    };
    if (maxTokens != null) {
      jsonBody.addAll({'max_tokens': maxTokens});
    }

    return json.encode(jsonBody);
  }
}

class Message {
  final String? role;
  final String? content;

  Message({this.role, this.content});

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      role: json['role'],
      content: json['content'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'role': role,
      'content': content,
    };
  }
}


