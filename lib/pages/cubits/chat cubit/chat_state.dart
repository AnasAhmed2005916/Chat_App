import 'package:chat_app/models/message.dart';

class ChatState {}

class ChatInitial extends ChatState {}

class ChatSuccess extends ChatState {
  List<Message> messagesList;
  ChatSuccess({required this.messagesList});
}
