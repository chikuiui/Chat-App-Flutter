import 'dart:async';

// Packages
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

// Services
import '../services/database_service.dart';
import '../services/cloud_storage_service.dart';
import '../services/media_service.dart';
import '../services/navigation_service.dart';


// Providers
import '../providers/authentication_provider.dart';

// Models
import '../models/chat_message.dart';


class ChatScreenProvider extends ChangeNotifier {

  ChatScreenProvider(
    this.chatId,
    this.auth,
    this.messagesListViewController
  ) {
    db = GetIt.instance.get<DatabaseService>();
    storage = GetIt.instance.get<CloudStorageService>();
    media = GetIt.instance.get<MediaService>();
    navigation = GetIt.instance.get<NavigationService>();
    keyboardVisibilityController = KeyboardVisibilityController();
    listenToMessage();
    listenToKeyboardChanges();
  }


  late DatabaseService db;
  late CloudStorageService storage;
  late MediaService media;
  late NavigationService navigation;

  AuthenticationProvider auth;
  ScrollController messagesListViewController;

  String chatId;
  List<ChatMessage>? messages;


  // to store and get message
  String? _message;
  String? get message => _message;
  void set message(String? value) {
    _message = value;
  }

  
  late StreamSubscription _messageStream;
  late StreamSubscription _keyboardVisibilityStream;
  late KeyboardVisibilityController keyboardVisibilityController;

  // to dispose of the streams we are listening to.
  @override
  void dispose() {
    _messageStream.cancel();
    super.dispose();
  }
  
  
  void listenToMessage () {
    try{
      _messageStream = db.streamMessagesForChat(chatId).listen(
          (snapshot) {
             List<ChatMessage> streamMessages = snapshot.docs.map((m){
               Map<String,dynamic> messageData = m.data() as Map<String,dynamic>;
               return ChatMessage.fromJSON(messageData);
             }).toList();

             messages = streamMessages;
             notifyListeners();

             // Add scroll to bottom call  means directly scroll to bottom after every msg
             // we using addPostFrameCallback is bcz flutter will not know when we get the new msg updated
             WidgetsBinding.instance.addPostFrameCallback((_){
               if(messagesListViewController.hasClients){
                 messagesListViewController.jumpTo(messagesListViewController.position.maxScrollExtent);
               }
             });



          }
      );
    }catch(e){
      print('Error getting messages');
      print(e);
    }
  }

  void listenToKeyboardChanges(){
    _keyboardVisibilityStream = keyboardVisibilityController.onChange.listen(
        (event){
          db.updateChatData(chatId, {
             'is_activity' : event
          });
        }
    );
  }


  void goBack(){
    navigation.goBack();
  }

  void deleteChat(){
    goBack();
    db.deleteChat(chatId);
  }

  void sendTextMessage() {
    print(_message);
    if(_message != null){
      ChatMessage messageToSend = ChatMessage(
          senderId: auth.chatUser.uid,
          type: MessageType.text,
          content: _message!,
          sendTime: DateTime.now()
      );
      
      db.addMessageToChat(chatId, messageToSend);
    }
  }
  
  void sendImageMessage() async{
    try{
      PlatformFile? file = await media.pickImageFromLibrary();
      if(file != null){
        String? downloadUrl = await storage.saveChatImageToStorage(chatId, auth.chatUser.uid, file);

        ChatMessage messageToSend = ChatMessage(
            senderId: auth.chatUser.uid,
            type: MessageType.image,
            content: downloadUrl!,
            sendTime: DateTime.now()
        );

        db.addMessageToChat(chatId, messageToSend);

      }
      
    }catch(e){
      print('Error sending image message');
      print(e);
    }
  }



}