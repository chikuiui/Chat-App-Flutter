// Package
import 'package:flutter/material.dart';

// Screens
import '../screens/chats_screen.dart';
import '../screens/user_screen.dart';

class HomeScreen extends StatefulWidget{
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() {
    return _HomeScreenState();
  }
}


class _HomeScreenState extends State<HomeScreen>{
  int currentScreen = 0;
  final List<Widget> _screens = [
    const ChatsScreen(),
    const UserScreen()
  ];



  @override
  Widget build(BuildContext context) {
    return _buildUI();
  }




  Widget _buildUI(){
    return Scaffold(
       body: _screens[currentScreen] ,
       bottomNavigationBar: BottomNavigationBar(
           currentIndex: currentScreen,
           onTap: (index){
             setState(() {
               currentScreen = index;
             });
           },
           items: const[
              BottomNavigationBarItem(label: 'Chats', icon: Icon(Icons.chat_bubble_sharp)),
              BottomNavigationBarItem(label: 'Users', icon: Icon(Icons.supervised_user_circle_sharp)),
           ]
       ),
    );
  }





}