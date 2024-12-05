import 'dart:async';

// Packages
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';

// Services
import '../services/database_service.dart';

// Providers
import 'authentication_provider.dart';

// Models
import '../models/chat_user.dart';
import '../models/chat_message.dart';
import '../models/chat.dart';


class ChatsScreenProvider extends ChangeNotifier{
  AuthenticationProvider auth;
  late DatabaseService db;

  List<Chat>? chats;

  late StreamSubscription _chatsStream;

  ChatsScreenProvider(this.auth) {
    db = GetIt.instance.get<DatabaseService>();
    getChats();
  }


  // When chat screen provider no longer needed
  @override
  void dispose(){
    _chatsStream.cancel();
    super.dispose();
  }

  void getChats() async {
    try {
      _chatsStream = db.getChatsForUser(auth.chatUser.uid).listen((snapshot) async {
                chats = await Future.wait(
                    snapshot.docs.map((document) async {
                      Map<String,dynamic> chatData = document.data() as Map<String,dynamic>;

                      // Get Users in Chat
                      List<ChatUser> members = [];
                      for ( var uid in chatData['members']){
                        DocumentSnapshot userSnapshot = await db.getUser(uid);
                        Map<String,dynamic> userData =
                            userSnapshot.data() as Map<String,dynamic>;
                        userData['uid'] = userSnapshot.id;  // or we can use uid directly by default ChatUser.fromJSON() fun req. uid but in userData we don't have so we explicty add it.
                        members.add(ChatUser.fromJSON(userData));
                      }

                      // Get Last Message For Chat
                      List<ChatMessage> messages = [];
                      QuerySnapshot chatMessage = await db.getLastMessageForChat(document.id);

                      if(chatMessage.docs.isNotEmpty){
                        Map<String,dynamic> messageData = chatMessage.docs.first.data()! as Map<String,dynamic>;
                        ChatMessage message = ChatMessage.fromJSON(messageData);
                        messages.add(message);
                      }



                      // return chat instance
                      return Chat(
                          uid: document.id,
                          currentUserUid: auth.chatUser.uid,
                          activity: chatData['is_activity'],
                          group: chatData['is_group'],
                          members: members,
                          messages: messages
                      );
                    }).toList()
                );
                notifyListeners();
      });

    }on FirebaseException {
      print('Related to Firebase.');
    } catch(e){
      print("Error getting chats.");
      print(e);
    }
  }



}