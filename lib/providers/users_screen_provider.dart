// Package
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';


// Services
import '../services/database_service.dart';
import '../services/navigation_service.dart';

// Provider
import '../providers/authentication_provider.dart';


// Models
import '../models/chat_user.dart';
import '../models/chat.dart';

// Screens
import '../screens/chat_screen.dart';


class UsersScreenProvider extends ChangeNotifier {


  UsersScreenProvider(this.auth){
    _selectedUsers = [];
    database = GetIt.instance.get<DatabaseService>();
    navigation = GetIt.instance.get<NavigationService>();
    getUsers();
  }


  AuthenticationProvider auth;

  late DatabaseService database;
  late NavigationService navigation;

  List<ChatUser>? users;

  late List<ChatUser> _selectedUsers;
  List<ChatUser> get selectedUsers {
    return _selectedUsers;
  }


  @override
  void dispose() {
    super.dispose();
  }


  void getUsers({String? name}) async {
    _selectedUsers = [];

    try{
      database.getUsers(name).then(
          (snapshot){
            users = snapshot.docs.map(
                 (doc){
                    Map<String,dynamic> data = doc.data() as Map<String,dynamic>;
                    data['uid'] = doc.id;
                    // Check if the uid is not the current user's uid
                    if (data['uid'] != auth.chatUser.uid) {
                      return ChatUser.fromJSON(data);
                    } else {
                      return null; // Exclude the current user
                    }
                 }
            ) .where((user) => user != null) // Remove null entries
                .cast<ChatUser>() // Cast to the appropriate type
                .toList();
            notifyListeners();
          }
      );
    }catch(e){
      print('Error getting users');
      print(e);
    }
  }


  void updateSelectedUsers(ChatUser user){
    if(_selectedUsers.contains(user)){
      _selectedUsers.remove(user);
    }else{
      _selectedUsers.add(user);
    }
    notifyListeners(); // to render.
  }

  void createChat() async {
    try{
      // Create a Chat.
      List<String> membersIds = _selectedUsers.map((user) => user.uid ).toList();
      membersIds.add(auth.chatUser.uid); // have to add yourself into the chat also.

      bool isGroup = _selectedUsers.length > 1;
      DocumentReference? doc = await database.createChat({
        'is_group' : isGroup,
        'is_activity' : false,
        'members' : membersIds
      });

      // Navigate to Chat Page.
      List<ChatUser> members = [];
      for(var uid in membersIds){
        DocumentSnapshot userSnapshot = await database.getUser(uid);
        Map<String,dynamic> userData = userSnapshot.data() as Map<String,dynamic>;
        userData['uid'] = userSnapshot.id;
        members.add(ChatUser.fromJSON(userData));
      }

      ChatScreen screen = ChatScreen(
          chat: Chat(
              uid: doc!.id,
              currentUserUid: auth.chatUser.uid,
              activity: false,
              group: isGroup,
              members: members,
              messages: [])
      );

      _selectedUsers = [];
      notifyListeners();
      navigation.navigateToScreen(screen);

    }catch(e){
      print('Error creating chat');
      print(e);
    }
  }



}