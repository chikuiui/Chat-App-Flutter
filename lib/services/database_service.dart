// Packages
import 'package:cloud_firestore/cloud_firestore.dart';

// Models
import '../models/chat_message.dart';


const String userCollection = 'Users';
const String chatCollection = 'Chats';
const String messagesCollection = 'messages';



class DatabaseService{

  DatabaseService(){}

  final FirebaseFirestore db = FirebaseFirestore.instance;


  // Retrieve a single user info from firestore database
  Future<DocumentSnapshot> getUser(String uid){
    return db.collection(userCollection).doc(uid).get();
  }

  // Update the part of the document that is last_active.
  Future<void> updateUserLastSeenTime(String uid) async{
    try{
      await db.collection(userCollection).doc(uid).update({
        'last_active' : DateTime.now().toUtc()
      });
    }catch(e){
      print(e);
    }
  }

  // Saving user info into database
  Future<void> createUser(String uid, String name, String email, String imageUrl) async{
    try{
      await db.collection(userCollection).doc(uid).set({
        'name' : name,
        'email' : email,
        'image' : imageUrl,
        'last_active' : DateTime.now().toUtc(),
      });
    }catch(e){
      print(e);
    }
  }
  
  
  // Getting Chats
  Stream<QuerySnapshot> getChatsForUser(String uid){
    return db.collection(chatCollection).where('members',arrayContains: uid).snapshots();
  }

  // Getting Last Message From Chats.
  Future<QuerySnapshot> getLastMessageForChat(String chatId){
    return db.collection(chatCollection)
        .doc(chatId)
        .collection(messagesCollection)
        .orderBy('sent_time', descending: true)
        .limit(1)
        .get();
  }
  
  // Getting Chat Messages.
  Stream<QuerySnapshot> streamMessagesForChat(String chatId){
    return db.collection(chatCollection)
        .doc(chatId)
        .collection(messagesCollection)
        .orderBy('sent_time', descending: false)
        .snapshots();
  }

  // Delete a Chat
  Future<void> deleteChat(String chatId) async{
    try{
      await db.collection(chatCollection).doc(chatId).delete();
    }catch(e){
      print(e);
    }
  }

  // Add Message to chat
  Future<void> addMessageToChat(String chatId,ChatMessage message) async{
    try{
      await db.collection(chatCollection).doc(chatId).collection(messagesCollection).add(
        message.toJson()
      );

    }catch(e){
      print(e);
    }
  }

  // Update Chat - allows us to update parts of data .
  Future<void> updateChatData(String chatId, Map<String,dynamic> data) async {
    try{
      await db.collection(chatCollection).doc(chatId).update(data);
    }catch(e){
      print(e);
    }
  }


  // Get users.
  Future<QuerySnapshot> getUsers(String? name){
    Query query = db.collection(userCollection);

    if(name != null){
      query = query
          .where('name',isGreaterThanOrEqualTo: name)
          .where('name',isLessThanOrEqualTo: '${name}z');
    }
    return query.get();
  }

  Future<DocumentReference?> createChat(Map<String,dynamic> data) async{
    try{
      DocumentReference chat = await db.collection(chatCollection).add(data);
      return chat;
    }catch(e){
      print(e);
    }
    return null;
  }





}