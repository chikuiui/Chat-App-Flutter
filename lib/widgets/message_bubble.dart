import 'package:flutter/material.dart';

// Packages
import 'package:timeago/timeago.dart' as timeago;

// Models
import '../models/chat_message.dart';


class TextMessageBubble extends StatelessWidget {

  const TextMessageBubble({
    super.key,
    required this.isOwnMessage,
    required this.message,
    required this.height,
    required this.width
  });

  final bool isOwnMessage;
  final ChatMessage message;
  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {


    List<Color> colorScheme = isOwnMessage ?
    const [Color.fromRGBO(0, 136, 249, 1.0), Color.fromRGBO(0, 82, 218, 1.0)] :
    const [Color.fromRGBO(51 , 49, 68, 1.0), Color.fromRGBO(51, 49, 68, 1.0)];

    return Container(
      height: height + (message.content.length / 20 * 6.0),
      width: width,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: LinearGradient(
              colors: colorScheme,
              stops: const [0.30,0.70],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight
          )
      ),
      alignment: isOwnMessage ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment:isOwnMessage ? CrossAxisAlignment.end: CrossAxisAlignment.start,
        children: [
          Text(
            message.content,
            style: const TextStyle(color: Colors.white),
          ),
          Text(
            timeago.format(message.sendTime),
            style: const TextStyle(color: Colors.white70),
          ),
        ],
      ),
    );
  }
}


class ImageMessageBubble extends StatelessWidget{
  const ImageMessageBubble({
    super.key,
    required this.isOwnMessage,
    required this.message,
    required this.height,
    required this.width
  });

  final bool isOwnMessage;
  final ChatMessage message;
  final double height;
  final double width;




  @override
  Widget build(BuildContext context) {
    List<Color> colorScheme = isOwnMessage ?
    const [Color.fromRGBO(0, 136, 249, 1.0), Color.fromRGBO(0, 82, 218, 1.0)] :
    const [Color.fromRGBO(51 , 49, 68, 1.0), Color.fromRGBO(51, 49, 68, 1.0)];

    DecorationImage image = DecorationImage(
        image: NetworkImage(message.content),
        fit: BoxFit.cover
    );

    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: width * 0.02,
          vertical: height * 0.03
      ),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          gradient: LinearGradient(
              colors: colorScheme,
              stops: const [0.30,0.70],
              begin: Alignment.bottomLeft,
              end: Alignment.topRight
          )
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment:isOwnMessage ? CrossAxisAlignment.end: CrossAxisAlignment.start,
        children: [
          Container(
            height: height,
            width: width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              image: image
            ),
          ),
          SizedBox(height: height * 0.02),
          Padding(
            padding: const EdgeInsets.only(left: 5,right: 5),
            child: Text(
              timeago.format(message.sendTime),
              style: const TextStyle(color: Colors.white70),
            ),
          ),
        ],
      ),
    );

  }

}