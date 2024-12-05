// Packages

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';

// Services
import '../services/database_service.dart';
import '../services/navigation_service.dart';

// Models
import '../models/chat_user.dart';

// ChangeNotifier => it provides other class to listen to changes happen within this class.
class AuthenticationProvider extends ChangeNotifier {

   late final FirebaseAuth auth;
   late final NavigationService navigationService;
   late final DatabaseService databaseService;

   late ChatUser chatUser;

   AuthenticationProvider(){
     auth = FirebaseAuth.instance;
     navigationService = GetIt.instance.get<NavigationService>();
     databaseService = GetIt.instance.get<DatabaseService>();

     auth.signOut();


     // allows us to listen to the changes happens in authentication of user so that we can proceed to next screen.
     // unified interface so that throughout the app we can check it.
     auth.authStateChanges().listen((user){
       if(user != null){
         // to update last seen
         databaseService.updateUserLastSeenTime(user.uid);
         // extract user info.
         databaseService.getUser(user.uid).then((snapshot){
           Map<String,dynamic> userData = snapshot.data()! as Map<String,dynamic>;
           chatUser = ChatUser.fromJSON(
             {
              'uid' : user.uid ,
              'name' : userData['name'],
              'email' : userData['email'],
              'last_active' : userData['last_active'],
              'image' : userData['image']
             }
           );
           print(chatUser.toMap());

           // Navigate to home page
           navigationService.removeAndNavigateToRoute('/home');
         });
       }else{
           navigationService.removeAndNavigateToRoute('/login');
       }
     });
   }

   Future<void> loginUsingEmailAndPassword(String email, String password) async{
     try{
       await auth.signInWithEmailAndPassword(email: email, password: password);
     }on FirebaseAuthException{
       print('Error logging user into Firebase');
     }catch(e){
       print(e);
     }
   }
   
   // return a string bcz we might fail sign up
   Future<String?> signUpUserUsingEmailAndPassword(String email, String password) async{
     try{
       UserCredential credential = await auth.createUserWithEmailAndPassword(email: email, password: password);
       return credential.user!.uid;
     }on FirebaseAuthException {
       print('Error registering user.');
     } catch(e){
       print(e);
     }
     return null;
   }


   Future<void> logout() async {
     try{
       await auth.signOut();
     }catch(e){
       print(e);
     }
   }

}



