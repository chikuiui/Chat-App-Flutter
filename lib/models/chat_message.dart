

import 'package:cloud_firestore/cloud_firestore.dart';

enum MessageType {
  text,
  image,
  unknown
}


class ChatMessage {
  final String senderId;
  final MessageType type;
  final String content;
  final DateTime sendTime;

  ChatMessage({
    required this.senderId,
    required this.type,
    required this.content,
    required this.sendTime
  });

  // can easily fetch from firebase.
  factory ChatMessage.fromJSON(Map<String,dynamic> json){
    MessageType messageType;
    switch(json['type']){
      case 'text' :
        messageType = MessageType.text;
        break;
      case 'image' :
        messageType = MessageType.image;
        break;
      default :
        messageType = MessageType.unknown;
    }
    
    return ChatMessage(
        senderId: json['sender_id'],
        type: messageType,
        content: json['content'],
        sendTime: json['sent_time'].toDate()
    );
  }

  // return a json representation of our message.
  Map<String, dynamic> toJson(){
    String messageType;
    switch(type){
      case MessageType.text :
        messageType = 'text';
        break;
      case MessageType.image :
        messageType = 'image';
        break;
      default :
        messageType = 'unknown';
    }
    return {
      'content' : content,
      'type' : messageType,
      'sender_id' : senderId,
      'sent_time' : Timestamp.fromDate(sendTime)
    };
  }
}