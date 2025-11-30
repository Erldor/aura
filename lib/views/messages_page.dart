import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:messenger/data/app_theme.dart';
import 'package:messenger/views/messages_page.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:http/http.dart' as http;

String serverAddress = "ws://10.0.2.2:8000/ws";

class MessagesPage extends StatefulWidget {
  MessagesPage({super.key});

  @override
  State<MessagesPage> createState() => _MessagesPageState();
}


class _MessagesPageState extends State<MessagesPage> {
  final messageController = TextEditingController();  //  Controller for input message form

  String? messageText;  //  Input message

  List<MessageContainer> messages = [MessageContainer(messageText: "Init")]; //  Messages list for output

  //  late WebSocketChannel channel;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose()
  {
  //  channel.sink.close();
    messageController.dispose();
    super.dispose();
  }


  //  Bottom navigation bar destination
  Widget bottomInputBar()
  {
    return Row(children: [
      Expanded(child: Container(margin: EdgeInsets.only(bottom: 15, top: 15, left: 15, right: 5), 
        child: TextField(
          decoration: InputDecoration(hintText: "Сообщение", 
            border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10)))), 
          controller: messageController, maxLines: 1,
        ),)
      ),
      IconButton(
        onPressed: ()
        {
          messageText = messageController.text;
          messages.add(MessageContainer(messageText: messageText!));
          messageController.clear();
          FocusScope.of(context).unfocus(); 
          setState(() {
            
          });
        }, 
        icon: Icon(Icons.send_sharp))
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return
      Scaffold(
        body: Stack(
          children: [
            Positioned(child: ListView(children: messages)),  //  Messages
            Positioned(bottom: 0, left: 0, right: 0, child: SafeArea(bottom: true, child: bottomInputBar())), //  Bottom input bar
          ],
        )
      );
  }
}


class MessageContainer extends StatelessWidget {

  final String messageText;
  const MessageContainer({super.key, required this.messageText});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5), padding: EdgeInsets.only(right: 15, left: 15, top: 5, bottom: 7), 
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.7, // макс. 70% ширины экрана
            minWidth: 80
          ),
          decoration: BoxDecoration(color: AppTheme.mainYellowColor, 
            borderRadius: BorderRadius.all(Radius.circular(10))), 
          child: 
          Text(softWrap: true, messageText, style: TextStyle(fontSize: 15),),
        ),
      ],
    );
  }
}