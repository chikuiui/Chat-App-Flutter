// Packages


import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

// Providers
import '../providers/authentication_provider.dart';
import '../providers/chats_screen_provider.dart';


// Widgets
import '../widgets/top_bar.dart';
import '../widgets/custom_list_view_tiles.dart';

// Models
import '../models/chat.dart';
import '../models/chat_user.dart';
import '../models/chat_message.dart';


// Service
import '../services/navigation_service.dart';

// Screen
import '../screens/chat_screen.dart';

class ChatsScreen extends StatefulWidget{
  const ChatsScreen({super.key});

  @override
  State<ChatsScreen> createState() {
    return _ChatsScreenState();
  }

}

class _ChatsScreenState extends State<ChatsScreen>{
  late double _deviceHeight;
  late double _deviceWidth;

  late AuthenticationProvider _auth;
  late ChatsScreenProvider _screenProvider;
  late NavigationService navigation;

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;

    _auth = Provider.of<AuthenticationProvider>(context);
    navigation = GetIt.instance.get<NavigationService>();

    return MultiProvider(
        providers: [
          ChangeNotifierProvider<ChatsScreenProvider>(create: (_) => ChatsScreenProvider(_auth))
        ],
        child: _buildUI(),
    );
  }


  Widget _buildUI(){

    // i am using builder bcz i need context and the alternative is
    // i can pass context from _buildUI to directly access the context.
    return Builder(
        builder: (BuildContext context) {
          _screenProvider = context.watch<ChatsScreenProvider>();

          return Container(
            padding: EdgeInsets.symmetric(
                horizontal: _deviceWidth * 0.03,
                vertical: _deviceHeight * 0.02
            ),
            height: _deviceHeight * 0.98,
            width: _deviceWidth * 0.97,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CustomTopBar(
                  'Chats',
                  primaryAction: IconButton(
                    icon : const Icon(Icons.logout),
                    color: const Color.fromRGBO(0, 82, 218, 1.0),
                    onPressed: (){
                      _auth.logout();
                    },
                  ),
                ),
                _chatsList()
              ],
            ),
          );
        }
    );
  }


  Widget _chatsList(){
    List<Chat>? chats = _screenProvider.chats;
    return Expanded(
        child: ((){  // anonymous fun
           if(chats != null){
             if(chats.isNotEmpty){
               return ListView.builder(
                   itemCount: chats.length,
                   itemBuilder: (BuildContext context, int index){
                     return _chatTile(chats[index]);
                   },
               );
             }else{
               return const Center(child: Text('No Chats Found.', style : TextStyle(color: Colors.white)));
             }
           }else{
             return const Center(child: CircularProgressIndicator(color: Colors.white,),);
           }
        })()
    );
  }


  // going to return
  Widget _chatTile(Chat chat){

    List<ChatUser> recipients = chat.recipients();
    bool isActive = recipients.any((d) => d.wasRecentlyActive());
    String subtitleText = '';
    if(chat.messages.isNotEmpty){
      subtitleText = chat.messages.first.type != MessageType.text ? 'Media Attachment' : chat.messages.first.content;
    }
    print('Users -> ${chat.title()}  and ${chat.members}');
    return CustomListViewTileWithActivity(
        height:_deviceHeight * 0.10,
        title: chat.title(),
        subtitle: subtitleText,
        imagePath: chat.imageURL(),
        isActive: isActive,
        isActivity: chat.activity,
        onTap: (){
           navigation.navigateToScreen(
             ChatScreen(chat: chat)
           );
        }
    );
  }

}