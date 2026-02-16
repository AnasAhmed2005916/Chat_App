import 'package:chat_app/constants.dart';
import 'package:chat_app/pages/cubits/chat%20cubit/chat_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit() : super(ChatInitial());
  CollectionReference messages = FirebaseFirestore.instance.collection(
    kMessagesCollections,
  );
  void sendMessage({required String message, required String email}) {
    messages.add({'text': message, 'createdAt': DateTime.now(), 'id': email});
  }

  void getMessages() {
    messages.orderBy('createdAt').snapshots().listen((event) {});
    emit(ChatSuccess());
  }
}
