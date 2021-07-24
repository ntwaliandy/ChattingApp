//@dart=2.9

import 'package:chatapp_draft/services/constant.dart';
import 'package:chatapp_draft/services/database.dart';
import 'package:flutter/material.dart';

class ConversationScreen extends StatefulWidget {
  final String chatRoomId;
  ConversationScreen(this.chatRoomId);
  @override
  _ConversationScreenState createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  DatabaseMethods databaseMethods = new DatabaseMethods();
  TextEditingController messageController = new TextEditingController();
  Stream chatMessageStream;

  Widget chatMessageList() {
    return StreamBuilder(
      stream: chatMessageStream,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  return MessageTile(
                      snapshot.data.docs[index].data()['message'],
                      snapshot.data.docs[index].data()['sendBy'] ==
                          Constants.myEmail);
                },
              )
            : Container();
      },
    );
  }

  sendMessage() {
    if (messageController.text.isNotEmpty) {
      Map<String, dynamic> messageMap = {
        'message': messageController.text,
        'sendBy': Constants.myEmail,
        'time': DateTime.now().microsecondsSinceEpoch
      };
      databaseMethods.addConversationMessages(widget.chatRoomId, messageMap);
      messageController.text = '';
    }
  }

  @override
  void initState() {
    databaseMethods.getConversationMessages(widget.chatRoomId).then((value) {
      setState(() {
        chatMessageStream = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.black,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0.0,
        title: Text(
          'In Box',
          style: TextStyle(
            letterSpacing: 2.0,
            fontWeight: FontWeight.bold,
            fontSize: 24.0,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Stack(children: [
              chatMessageList(),
            ]),
          ),
          Container(
            alignment: Alignment.bottomCenter,
            child: Container(
              color: Color(0x54FFFFFF),
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      textInputAction: TextInputAction.newline,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      controller: messageController,
                      style: TextStyle(
                        letterSpacing: 2.0,
                        color: Colors.white,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Type your Message Here.......',
                        hintStyle: TextStyle(
                          color: Colors.white54,
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      sendMessage();
                    },
                    child: Container(
                      height: 45,
                      width: 55,
                      decoration: BoxDecoration(
                          gradient: LinearGradient(colors: [
                            const Color(0x36FFFFFF),
                            const Color(0x0FFFFFFF),
                          ]),
                          borderRadius: BorderRadius.circular(40)),
                      padding: EdgeInsets.all(10),
                      child: Icon(Icons.send),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MessageTile extends StatelessWidget {
  final String message;
  final bool isSentByMe;
  MessageTile(this.message, this.isSentByMe);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          left: isSentByMe ? 0 : 24, right: isSentByMe ? 24 : 0),
      margin: EdgeInsets.symmetric(vertical: 8),
      width: MediaQuery.of(context).size.width,
      alignment: isSentByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isSentByMe
                ? [const Color(0xff007EF4), const Color(0xff2A75BC)]
                : [const Color(0x1AFFFFFF), const Color(0x1AFFFFFF)],
          ),
          borderRadius: isSentByMe
              ? BorderRadius.only(
                  topRight: Radius.circular(23),
                  topLeft: Radius.circular(23),
                  bottomLeft: Radius.circular(23),
                )
              : BorderRadius.only(
                  topLeft: Radius.circular(23),
                  topRight: Radius.circular(23),
                  bottomRight: Radius.circular(23)),
        ),
        child: Text(
          message,
          style: TextStyle(
            color: Colors.white,
            fontSize: 17,
          ),
        ),
      ),
    );
  }
}
