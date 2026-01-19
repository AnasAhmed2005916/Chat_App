import 'dart:convert';

class Message {
  final String text;
  final String id;
  Message({required this.text , required this.id});
  factory Message.fromJson(jsonData) {
    return Message(
      text: jsonData['text'] ?? '',
      id: jsonData['id'] ?? '',
      );
  }
}
