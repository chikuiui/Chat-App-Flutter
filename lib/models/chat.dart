// Models
import 'chat_user.dart';
import 'chat_message.dart';



class Chat {

  Chat({
    required this.uid,
    required this.currentUserUid,
    required this.activity,
    required this.group,
    required this.members,
    required this.messages
  }) { // when class is constructed i want to perform operations.

    // include all members excluding the members who actually log into the device.
    _recipients = members.where((i) => i.uid != currentUserUid).toList();
  }


  final String uid; // of a message
  final String currentUserUid;
  final bool activity;
  final bool group;
  final List<ChatUser> members;
  List<ChatMessage> messages;

  late final List<ChatUser> _recipients;


  List<ChatUser> recipients(){
    return _recipients;
  }

  String title() {
    return !group ? _recipients.first.name : _recipients.map((user) => user.name).join(",");
  }

  String imageURL(){
    return !group ? _recipients.first.imageURL
        : "https://e7.pngegg.com/pngimages/380/670/png-clipart-group-chat-logo-blue-area-text-symbol-metroui-apps-live-messenger-alt-2-blue-text.png";
  }

}

