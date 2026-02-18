import 'package:chat_app/constants.dart';
import 'package:chat_app/models/message.dart';
import 'package:chat_app/pages/cubits/chat%20cubit/chat_cubit.dart';
import 'package:chat_app/pages/cubits/chat%20cubit/chat_state.dart';
import 'package:chat_app/widgets/chat_bubble.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatPage extends StatelessWidget {
  static String id = 'Chat';
  late ScrollController controller = ScrollController();
  late TextEditingController textController = TextEditingController();
  List<Message> messages = [];
  void scrollToBottom() {
    controller.animateTo(
      controller.position.maxScrollExtent,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final String email = ModalRoute.of(context)!.settings.arguments as String;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.chat_outlined, size: 40),
            SizedBox(width: 20),
            Text(
              'Chat Page',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),

        backgroundColor: kPrimaryColor,
        centerTitle: true,
        automaticallyImplyLeading: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: BlocConsumer<ChatCubit, ChatState>(
              listener: (context, state) {
                if (state is ChatSuccess) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    controller.animateTo(
                      controller.position.maxScrollExtent,
                      duration: Duration(
                        milliseconds: 500,
                      ),
                      curve: Curves.easeInOutCubic,
                    );
                  });
                }
              },
              builder: (context, state) {
                if (state is ChatSuccess) {
                  final messagesList = state.messagesList;
                  return ListView.builder(
                    controller: controller,
                    itemCount: messagesList.length,
                    itemBuilder: (context, index) {
                      if (messagesList[index].id == email) {
                        return ChatBubble(message: messagesList[index]);
                      } else {
                        return ChatBubbleForFriend(
                          message: messagesList[index],
                        );
                      }
                    },
                  );
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: textController,
              onSubmitted: (value) {
                context.read<ChatCubit>().sendMessage(
                  message: value,
                  email: email,
                );
                textController.clear();
              },
              decoration: InputDecoration(
                hintText: 'Send Message',
                suffixIcon: Icon(Icons.send, color: kPrimaryColor),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: kPrimaryColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: Colors.blue),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
