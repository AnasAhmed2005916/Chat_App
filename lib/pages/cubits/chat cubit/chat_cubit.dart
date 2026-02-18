import 'package:chat_app/constants.dart';
import 'package:chat_app/models/message.dart';
import 'package:chat_app/pages/cubits/chat%20cubit/chat_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit() : super(ChatInitial());
  CollectionReference messages = FirebaseFirestore.instance.collection(
    kMessagesCollections,
  );
  void sendMessage({required String message, required String email}) {
    try {
      messages.add({'text': message, 'createdAt': DateTime.now(), 'id': email});
    } on Exception catch (e) {}
  }

  void getMessages() {
    List<Message> messagesList = [];
    messages.orderBy('createdAt').snapshots().listen((event) {
      for (var doc in event.docs) {
        messagesList.add(Message.fromJson(doc.data() as Map<String, dynamic>));
      }
      emit(ChatSuccess(messagesList: messagesList));
    });
  }
}
