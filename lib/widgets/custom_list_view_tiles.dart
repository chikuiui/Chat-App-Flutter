// Packages
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart'; // Loading Animations

// Widgets
import '../widgets/rounded_image.dart';
import '../widgets/message_bubble.dart';

// Models
import '../models/chat_message.dart';
import '../models/chat_user.dart';




class CustomListViewTile extends StatelessWidget {
  const CustomListViewTile({
    super.key,
    required this.height,
    required this.title,
    required this.subtitle,
    required this.imagePath,
    required this.isActive,
    required this.isSelected,
    required this.onTap
  });

  final double height;
  final String title;
  final String subtitle;
  final String imagePath;
  final bool isActive;
  final bool isSelected;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      trailing: isSelected ? const Icon(Icons.check,color: Colors.white) : null,
      onTap:()=> onTap(),
      minVerticalPadding: height * 0.20,
      leading: RoundedImageNetworkWithStatusIndicator(imagePath: imagePath, size: height/2, isActive: isActive),
      title: Text(title,style: const TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.w500)),
      subtitle: Text(subtitle,style: const TextStyle(color: Colors.white54,fontSize: 12,fontWeight: FontWeight.w400)),

    );
  }

}




class CustomListViewTileWithActivity extends StatelessWidget {
  const CustomListViewTileWithActivity(
      {super.key,
      required this.height,
      required this.title,
      required this.subtitle,
      required this.imagePath,
      required this.isActive,
      required this.isActivity,
      required this.onTap});

  final double height;
  final String title;
  final String subtitle;
  final String imagePath;
  final bool isActive;
  final bool isActivity; // is someone typing in chat or not
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => onTap(),
      minVerticalPadding: height * 0.20,
      leading: RoundedImageNetworkWithStatusIndicator(
          imagePath: imagePath, size: height / 2, isActive: isActive),
      title: Text(
        title,
        style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w500
        ),
      ),
      subtitle: isActivity
          ? Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SpinKitThreeBounce(// animation
                  color: Colors.white54,
                  size: height * 0.10,
                ),
              ],
            )
          : Text(
              subtitle,
              style: const TextStyle(
                  color: Colors.white54,
                  fontSize: 12,
                  fontWeight: FontWeight.w400),
            ),
    );
  }
}


class CustomChatListViewTile extends StatelessWidget{

  const CustomChatListViewTile({
    super.key,
    required this.deviceHeight,
    required this.width,
    required this.message,
    required this.isOwnMessage,
    required this.sender,
  });

  final double width;
  final double deviceHeight;
  final bool isOwnMessage;
  final ChatMessage message;
  final ChatUser sender;

  @override
  Widget build(BuildContext context) {
     return Container(
       padding: const EdgeInsets.only(bottom:10),
       width: width,
       child: Row(
         mainAxisSize: MainAxisSize.max,
         mainAxisAlignment: isOwnMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
         crossAxisAlignment: CrossAxisAlignment.end,
         children: [
           // Rounded Image
           !isOwnMessage ? RoundedImageNetwork(imagePath: sender.imageURL, size: width * 0.08) : Container(),
           SizedBox(width: width * 0.05),

           message.type == MessageType.text ?
             TextMessageBubble(
                 isOwnMessage: isOwnMessage,
                 message: message,
                 height: deviceHeight * 0.06,
                 width: width
             ) :
             ImageMessageBubble(
                 isOwnMessage: isOwnMessage,
                 message: message,
                 height: deviceHeight * 0.30,
                 width: width * 0.55
             )
         ],
       ),
     );
  }
}

