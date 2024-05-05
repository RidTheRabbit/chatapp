import 'package:chatapp/utils/notification.dart';
import 'package:chatapp/utils/notification_setup.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:chatapp/models/messages.dart';
import 'package:chatapp/components/C_chatBuble.dart';
import 'package:chatapp/consts.dart';
import 'package:http/http.dart' as http;

class ChatBubleScreen extends StatefulWidget {
  const ChatBubleScreen({super.key});
  static String id = 'ChatBubleScreen';

  @override
  State<ChatBubleScreen> createState() => _ChatBubleScreenState();
}

class _ChatBubleScreenState extends State<ChatBubleScreen> {
  final TextEditingController messageController = TextEditingController();
  late ScrollController listViewController;
  double scrollPosition = 0.0;
  String? _token;
  String? initialMessage;
  bool _resolved = false;

  @override
  void initState() {
    super.initState();
    listViewController = ScrollController();
    listViewController.addListener(() {
      scrollPosition = listViewController.offset;
    });

    FirebaseMessaging.instance.getInitialMessage().then(
          (value) => setState(
            () {
              _resolved = true;
              initialMessage = value?.data.toString();
            },
          ),
        );

    FirebaseMessaging.onMessage.listen(showFlutterNotification);

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
      Navigator.pushNamed(
        context,
        ChatBubleScreen.id,
        arguments: MessageArguments(message, true),
      );
    });
  }

  Future<void> sendPushMessage() async {
    if (_token == null) {
      print('Unable to send FCM message, no token exists.');
      return;
    }

    try {
      await http.post(
        Uri.parse('https://api.rnfirebase.io/messaging/send'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: constructFCMPayload(_token),
      );
      print('FCM request for device sent!');
    } catch (e) {
      print(e);
    }
  }

  Future<void> onActionSelected(String value) async {
    switch (value) {
      case 'subscribe':
        {
          print(
            'FlutterFire Messaging Example: Subscribing to topic "fcm_test".',
          );
          await FirebaseMessaging.instance.subscribeToTopic('fcm_test');
          print(
            'FlutterFire Messaging Example: Subscribing to topic "fcm_test" successful.',
          );
        }
        break;
      case 'unsubscribe':
        {
          print(
            'FlutterFire Messaging Example: Unsubscribing from topic "fcm_test".',
          );
          await FirebaseMessaging.instance.unsubscribeFromTopic('fcm_test');
          print(
            'FlutterFire Messaging Example: Unsubscribing from topic "fcm_test" successful.',
          );
        }
        break;
      case 'get_apns_token':
        {
          if (defaultTargetPlatform == TargetPlatform.iOS ||
              defaultTargetPlatform == TargetPlatform.macOS) {
            print('FlutterFire Messaging Example: Getting APNs token...');
            String? token = await FirebaseMessaging.instance.getAPNSToken();
            print('FlutterFire Messaging Example: Got APNs token: $token');
          } else {
            print(
              'FlutterFire Messaging Example: Getting an APNs token is only supported on iOS and macOS platforms.',
            );
          }
        }
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    var email = ModalRoute.of(context)!.settings.arguments;
    CollectionReference messages =
        FirebaseFirestore.instance.collection('messages');

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
          actions: <Widget>[
            PopupMenuButton(
              onSelected: onActionSelected,
              itemBuilder: (BuildContext context) {
                return [
                  const PopupMenuItem(
                    value: 'subscribe',
                    child: Text('Subscribe to topic'),
                  ),
                  const PopupMenuItem(
                    value: 'unsubscribe',
                    child: Text('Unsubscribe to topic'),
                  ),
                  const PopupMenuItem(
                    value: 'get_apns_token',
                    child: Text('Get APNs token (Apple only)'),
                  ),
                ];
              },
            )
          ]),
      floatingActionButton: Builder(
        builder: (context) => FloatingActionButton(
          onPressed: sendPushMessage,
          backgroundColor: Colors.white,
          child: const Icon(Icons.send),
        ),
      ),
      body: SafeArea(
        child: StreamBuilder<QuerySnapshot>(
          stream: messages.orderBy('date', descending: true).snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            List<MessagesModel> messagesList = [];
            for (int i = 0; i < snapshot.data!.docs.length; i++) {
              messagesList.add(MessagesModel.fromJson(snapshot.data!.docs[i]));
            }

            // Determine the index of the first unread message
            int firstUnreadIndex =
                messagesList.indexWhere((msg) => !msg.isRead);

            // Scroll to the first unread message if it exists
            if (firstUnreadIndex != -1) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                listViewController.animateTo(
                  firstUnreadIndex * 20, // Adjust height if needed
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                );
              });
            }

            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    controller: listViewController,
                    reverse: true,
                    itemCount: messagesList.length,
                    itemBuilder: (context, index) {
                      return messagesList[index].email == email
                          ? CchatBubble(
                              message: messagesList[index],
                            )
                          : CchatBubbleFriend(
                              message: messagesList[index],
                              snapshot: snapshot.data!.docs[index],
                            );
                    },
                  ),
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
                        'email': '$email',
                        'isRead': false
                      });
                      messageController.clear();
                      listViewController.animateTo(
                        0,
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeInOut,
                      );
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: const BorderSide(color: kBackgColor),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: const BorderSide(color: kBackgColor),
                      ),
                      hintText: 'Send A Message..',
                      suffixIcon: messageController.text.isNotEmpty
                          ? IconButton(
                              onPressed: () async {
                                await messages.add({
                                  'message': messageController.text,
                                  'date': DateTime.now(),
                                  'email': '$email',
                                  'isRead': false
                                });
                                messageController.clear();
                                listViewController.animateTo(
                                  0,
                                  duration: const Duration(milliseconds: 500),
                                  curve: Curves.easeInOut,
                                );
                              },
                              icon: const Icon(
                                Icons.send,
                                color: kBackgColor,
                              ),
                            )
                          : null,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
