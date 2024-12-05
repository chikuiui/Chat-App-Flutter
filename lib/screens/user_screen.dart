// Packages
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:get_it/get_it.dart';


// Provider
import '../providers/authentication_provider.dart';
import '../providers/users_screen_provider.dart';

// Widgets
import '../widgets/top_bar.dart';
import '../widgets/custom_input_fields.dart';
import '../widgets/custom_list_view_tiles.dart';
import '../widgets/rounded_button.dart';

// Models
import '../models/chat_user.dart';


// Screen



class UserScreen extends StatefulWidget{
  const UserScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _UserScreenState();
  }

}

class _UserScreenState extends State<UserScreen>{

  late double deviceHeight;
  late double deviceWidth;

  late AuthenticationProvider auth;
  late UsersScreenProvider screenProvider;

  final TextEditingController _searchFieldTextEditingController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    deviceHeight = MediaQuery.of(context).size.height;
    deviceWidth = MediaQuery.of(context).size.width;

    auth = Provider.of<AuthenticationProvider>(context);


    return MultiProvider(
        providers: [
          ChangeNotifierProvider<UsersScreenProvider>(create: (_) => UsersScreenProvider(auth))
        ],
        child: _buildUI(),
    );
  }

  Widget _buildUI(){
    return Builder(
        builder: (BuildContext context){
          screenProvider = context.watch<UsersScreenProvider>();

          return Container(
            padding: EdgeInsets.symmetric(
                horizontal: deviceWidth * 0.03 ,
                vertical: deviceHeight * 0.02
            ),
            height: deviceHeight * 0.98,
            width: deviceWidth * 0.97,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CustomTopBar(
                  'Users',
                  primaryAction: IconButton(
                      onPressed: (){
                        auth.logout();
                      },
                      icon: const Icon(
                        Icons.logout,
                        color: Color.fromRGBO(0, 82, 218, 1.0),)
                  ),
                ),
                CustomTextField(
                    onEditingComplete: (value){
                      screenProvider.getUsers(name: value);
                      FocusScope.of(context).unfocus();
                    },
                    icon: Icons.search,
                    hintText: 'Search...',
                    obscureText: false,
                    controller: _searchFieldTextEditingController
                ),
                _usersList(),
                _createChatButton()
              ],
            ),
          );
        }
    );
  }

/*
  Using a construct like () { }() in Dart involves creating an immediately invoked
  function expression (IIFE). This pattern is used to dynamically decide or calculate
  what widget to return at runtime.
*/

  Widget _usersList(){
    List<ChatUser>? users = screenProvider.users;

    return Expanded(
        child: () {
          if(users != null) {
            if(users.isNotEmpty){
              return ListView.builder(
                  itemCount: users.length,
                  itemBuilder: (BuildContext context, int index){
                    return CustomListViewTile(
                        height: deviceHeight * 0.10,
                        title: users[index].name,
                        subtitle: 'Last Active : ${users[index].lastDayActive()}',
                        imagePath: users[index].imageURL,
                        isActive: users[index].wasRecentlyActive(),
                        isSelected: screenProvider.selectedUsers.contains(users[index]),
                        onTap: (){
                          screenProvider.updateSelectedUsers(users[index]);
                        }
                    );
                  }
              );
            }else{
             return const Center(
               child: Text('No Users Found', style: TextStyle(color: Colors.white),),
             );
            }
          }else{
            return const Center(
              child: CircularProgressIndicator(color: Colors.white),
            );
          }
        }() // () at the end means you are telling dart you have to invoke that function.
    );
  }

  Widget _createChatButton() {
    return Visibility(
        visible: screenProvider.selectedUsers.isNotEmpty,
        child: RoundedButton(
            name: screenProvider.selectedUsers.length == 1 ? 'Chat With ${screenProvider.selectedUsers.first.name}'
                : 'Create Group Chat',
            height: deviceHeight * 0.08,
            width: deviceWidth * 0.80,
            onPressed: (){
              screenProvider.createChat();
            }
        )
    );
  }
}