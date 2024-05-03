import 'package:chatapp/components/C_chatBuble.dart';
import 'package:chatapp/consts.dart';
import 'package:chatapp/models/messages.dart';
import 'package:chatapp/screens/login.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatBubleScreen extends StatefulWidget {
  const ChatBubleScreen({super.key});
  static String id = 'ChatBubleScreen';

  @override
  State<ChatBubleScreen> createState() => _ChatBubleScreenState();
}

class _ChatBubleScreenState extends State<ChatBubleScreen> {
  final TextEditingController messageController = TextEditingController();
  final ScrollController listViewController = ScrollController();

  @override
  Widget build(BuildContext context) {
    
   var email = ModalRoute.of(context)!.settings.arguments;
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    CollectionReference messages =
        FirebaseFirestore.instance.collection('messages');

    String? message;

    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: kBackgColor,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                kLogo,
                height: 55,
              ),
              const Text(
                'Chat',
                style: TextStyle(color: Colors.white),
              )
            ],
          ),
          centerTitle: true,
        ),
        body: SafeArea(
          child: StreamBuilder<QuerySnapshot>(
              stream: messages.orderBy('date', descending: true).snapshots(),
              builder: (context, snapshot) {
                List<MessagesModel> messagesList = [];
                if(snapshot.hasData){
                  for (int i = 0; i < snapshot.data!.docs.length; i++) {
                  messagesList
                      .add(MessagesModel.fromJson(snapshot.data!.docs[i]));
                }
                }
                return snapshot.hasData
                    ? Column(
                        children: [
                          Expanded(
                            child: ListView.builder(
                                controller: listViewController,
                                reverse: true,
                                itemCount: messagesList.length,
                                itemBuilder: (context, index) {
                                  return messagesList[index].email == email ? CchatBubble(
                                    message: messagesList[index],
                                  )
                                  : CchatBubbleFriend(message: messagesList[index]);
                                }),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextField(
                              controller: messageController,
                              onChanged: (value) {
                                setState(() {
                                  messageController.text = value;
                                });
                              },
                              onSubmitted: (value) {
                                messageController.text = value;
                                messages.add({
                                  'message': messageController.text,
                                  'date': DateTime.now(),
                                  'email': '$email'
                                });
                                messageController.clear();
                                listViewController.animateTo(0,
                                    duration: const Duration(seconds: 1),
                                    curve: Curves.easeIn);
                              },
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    borderSide:
                                        const BorderSide(color: kBackgColor),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    borderSide:
                                        const BorderSide(color: kBackgColor),
                                  ),
                                  hintText: 'Send A Message..',
                                  suffixIcon: messageController.text.isNotEmpty
                                      ? IconButton(
                                          onPressed: () async {
                                            await messages.add({
                                              'message': messageController.text,
                                              'date': DateTime.now(),
                                              'email': '$email'
                                            });
                                            messageController.clear();
                                            listViewController.animateTo(0,
                                                duration:
                                                    const Duration(seconds: 1),
                                                curve: Curves.easeIn);
                                          },
                                          icon: const Icon(
                                            Icons.send,
                                            color: kBackgColor,
                                          ))
                                      : null),
                            ),
                          )
                        ],
                      )
                    : const Center(child: Text('Loading'));
              }),
        ));
  }
}
