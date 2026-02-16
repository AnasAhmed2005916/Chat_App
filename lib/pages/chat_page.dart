import 'package:chat_app/constants.dart';
import 'package:chat_app/models/message.dart';
import 'package:chat_app/widgets/chat_bubble.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatPage extends StatefulWidget {
  static String id = 'Chat';

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late ScrollController _controller;
  late TextEditingController textController;

  CollectionReference messages = FirebaseFirestore.instance.collection(
    kMessagesCollections,
  );
  void initState() {
    super.initState();
    _controller = ScrollController();
    textController = TextEditingController();
    fixOldMessages();
  }

  @override
  void dispose() {
    _controller.dispose();
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String email = ModalRoute.of(context)!.settings.arguments as String;
    return StreamBuilder<QuerySnapshot>(
      // listen to the documents and update UI
      stream: messages.orderBy('createdAt').snapshots(), // return all documents
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Message> messagesList = [];
          for (int i = 0; i < snapshot.data!.docs.length; i++) {
            messagesList.add(Message.fromJson(snapshot.data!.docs[i]));
          }
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (_controller.hasClients) {
              _controller.animateTo(
                _controller.position.maxScrollExtent,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeIn,
              );
            }
          });
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
                  child: ListView.builder(
                    controller: _controller,
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
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: TextField(
                    controller: textController,
                    onSubmitted: (value) {
                      messages.add({
                        'text': value,
                        'createdAt': DateTime.now(),
                        'id': email,
                      });
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
        } else {
          return Center(child: Text('loading....'));
        }
      },
    );
  }
}

void fixOldMessages() async {
  final messages = FirebaseFirestore.instance.collection(kMessagesCollections);

  final snapshot = await messages.get();

  for (var doc in snapshot.docs) {
    if (!doc.data().containsKey('id')) {
      await messages.doc(doc.id).update({
        'id': 'unknown', // أو أي قيمة مناسبة
      });
    }
  }
}
