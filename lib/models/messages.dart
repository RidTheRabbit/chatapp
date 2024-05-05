import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MessagesModel {
  final String messageText;
  final DateTime date;
  final String email;
  final bool isRead;

  MessagesModel ({required this.messageText, required this.date, required this.email, required this.isRead});

  factory MessagesModel.fromJson(jsonData){
    return MessagesModel(messageText: jsonData['message'], date: jsonData['date'].toDate(), email: jsonData['email'], isRead:  jsonData['isRead']);
  }
}