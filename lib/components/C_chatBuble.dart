import 'package:chatapp/consts.dart';
import 'package:chatapp/models/messages.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CchatBubble extends StatelessWidget {
  const CchatBubble({required this.message, super.key});
  final MessagesModel message;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Container(
            margin:
                const EdgeInsets.only(top: 16, bottom: 16, left: 10, right: 40),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 17),
            decoration: const BoxDecoration(
                color: kBackgColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                )),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  message.messageText,
                  style: const TextStyle(color: Colors.white),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.check, color: Colors.grey,size: 22,),
                  ],
                )
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Align(
            alignment: Alignment.topLeft,
            child: Text(getTime())),
        )
      ],
    );
  }

  String getTime() {
    Duration diffrenceDate = DateTime.now().difference(message.date);
    String time;
    if(diffrenceDate.inDays>1) {
      return time = '${message.date.day}-${message.date.month}-${message.date.year}';
    } else {
      return time = '${message.date.hour}:${message.date.minute}';
    }
  }
}


class CchatBubbleFriend extends StatelessWidget {
  const CchatBubbleFriend({required this.message, super.key});
  final MessagesModel message;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: Container(
            margin:
                const EdgeInsets.only(top: 16, bottom: 16, left: 40, right: 10),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 17),
            decoration: const BoxDecoration(
                color: kBubleColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                  bottomLeft: Radius.circular(30),
                )),
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message.messageText,
                    style: const TextStyle(color: Colors.white),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.check, color: Colors.grey,size: 22,),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
        
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Align(
            alignment: Alignment.topRight,
            child: Text(getTime())),
        )
      ],
    );
  }
  
  String getTime() {
    Duration diffrenceDate = DateTime.now().difference(message.date);
    String time;
    if(diffrenceDate.inDays>1) {
      return time = '${message.date.day}-${message.date.month}-${message.date.year}';
    } else {
      return time = '${message.date.hour}:${message.date.minute}';
    }
  }
}
