// Packages
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


// Widgets
import '../widgets/top_bar.dart';
import '../widgets/custom_list_view_tiles.dart';
import '../widgets/custom_input_fields.dart';


// Models
import '../models/chat.dart';
import '../models/chat_message.dart';


// Providers
import '../providers/authentication_provider.dart';
import '../providers/chat_screen_provider.dart';


class ChatScreen extends StatefulWidget {
  const ChatScreen({
    super.key,
    required this.chat
  });

  final Chat chat;


  @override
  State<ChatScreen> createState() {
    return _ChatScreenState();
  }

}


class _ChatScreenState extends State<ChatScreen> {

  late double _deviceHeight;
  late double _deviceWidth;

  late AuthenticationProvider _auth;
  late ChatScreenProvider screenProvider;

  // can use late and initialize it on initState fun.
  final _messageFormKey = GlobalKey<FormState>();
  final _messagesListViewController = ScrollController();


  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;

    _auth = Provider.of<AuthenticationProvider>(context);


    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ChatScreenProvider>(create: (_) =>
            ChatScreenProvider(widget.chat.uid, _auth, _messagesListViewController)
        )
      ],
      child: _buildUI(),
    );
  }


  Widget _buildUI() {
    return Builder(builder: (context) {
      screenProvider = context.watch<ChatScreenProvider>();
      return Scaffold(
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(
                horizontal: _deviceWidth * 0.03,
                vertical: _deviceHeight * 0.02
            ),
            height: _deviceHeight,
            width: _deviceWidth * 0.97,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // this.widget = means able to access the parent class
                CustomTopBar(
                  widget.chat.title(),
                  fontSize: 10,
                  primaryAction: IconButton(
                    icon: const Icon(
                        Icons.delete, color: Color.fromRGBO(0, 82, 218, 1.0)),
                    onPressed: () {
                      _showDeleteConfirmationDialog(context);
                    },
                  ),
                  secondaryAction: IconButton(
                    icon: const Icon(Icons.arrow_back,
                        color: Color.fromRGBO(0, 82, 218, 1.0)),
                    onPressed: () {
                       screenProvider.goBack();
                    },
                  ),
                ),
                messagesListView(),
                sendMessageForm()
              ],
            ),
          ),
        ),
      );
    });
  }


  Widget messagesListView() {
    if (screenProvider.messages != null) {
      if (screenProvider.messages!.isNotEmpty) {
        return SizedBox(
          height: _deviceHeight * 0.74,
          child: ListView.builder(
              controller: _messagesListViewController,
              itemCount: screenProvider.messages!.length,
              itemBuilder: (BuildContext context, int index) {

                ChatMessage message = screenProvider.messages![index];
                bool isOwnMessage = message.senderId == _auth.chatUser.uid;

                return CustomChatListViewTile(
                    deviceHeight: _deviceHeight,
                    width: _deviceWidth * 0.80,
                    message: message,
                    isOwnMessage: isOwnMessage,
                    sender: widget.chat.members.where((member) => member.uid  == message.senderId).first
                );
              }
          ),
        );
      } else {
        return const Align(
          alignment: Alignment.center,
          child: Text(
            'Be the first to say Hi!',
            style: TextStyle(
                color: Colors.white
            ),
          ),
        );
      }
    } else {
      return const Center(
        child: CircularProgressIndicator(color: Colors.white,),
      );
    }
  }
  Widget sendMessageForm(){
    return Container(
      height: _deviceHeight * 0.06,
      decoration: BoxDecoration(
        color: const Color.fromRGBO(30, 29, 37, 1.0),
        borderRadius: BorderRadius.circular(100)
      ),
      margin: EdgeInsets.symmetric(
        horizontal: _deviceWidth * 0.04,
        vertical: _deviceHeight * 0.03
      ),
      child: Form(
          key: _messageFormKey,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _messageTextField(),
              _imageMessageButton(),
              _sendMessageButton()
            ],
          )
      ),
    );
  }
  Widget _messageTextField() {
    return SizedBox(
      width: _deviceWidth * 0.65,
      child: CustomTextFormField(
          onSaved: (value){
           screenProvider.message = value;
          },
          regEx: r"^(?!\s*$).+",
          hintText: 'Type a message' ,
          obscureText: false
      ),
    );
  }
  Widget _imageMessageButton(){
    double size = _deviceHeight * 0.04;
    
    return SizedBox(
      height: size,
      width: size,
      child: FloatingActionButton(
        backgroundColor: Color.fromRGBO(0, 82, 218, 1.0),
        onPressed: (){

        },
        child: const Icon(Icons.camera_enhance),
      ),
    );
  }
  Widget _sendMessageButton(){
    double size = _deviceHeight * 0.04;

    return SizedBox(
      height: size,
      width: size ,
      child: IconButton(
          onPressed: (){
            bool isValid = _messageFormKey.currentState!.validate();
            if(!isValid)return;
            _messageFormKey.currentState!.save();
            screenProvider.sendTextMessage();
            _messageFormKey.currentState!.reset();
          },
          icon: const Icon(Icons.send, color: Colors.white)
      ),
    );
  }


  void _showDeleteConfirmationDialog(BuildContext context){
    showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            title: const Text('Delete the Chat Group'),
            content: const Text('Are you sure you want to delete this group?'),
            actions: [
              TextButton(
                  onPressed: (){
                    Navigator.of(context).pop();
                  },
                  child: const Text("No" ,style: TextStyle(color: Colors.black,fontSize: 20))
              ),
              TextButton(
                  onPressed: (){
                    screenProvider.deleteChat();
                    Navigator.of(context).pop();
                  },
                  child: const Text("Yes",style: TextStyle(color: Colors.black,fontSize: 20))
              ),
            ],
          );
        }
    );
  }

}