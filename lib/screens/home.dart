//@dart=2.9
import 'package:chatapp_draft/screens/ChatRoom.dart';
import 'package:chatapp_draft/screens/search.dart';
import 'package:chatapp_draft/services/auth.dart';
import 'package:chatapp_draft/services/constant.dart';
import 'package:chatapp_draft/services/database.dart';
import 'package:chatapp_draft/services/helperfunctions.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  AuthService authService = new AuthService();
  DatabaseMethods databaseMethods = new DatabaseMethods();

  Stream chatRoomsStream;

  Widget chatRoomList() {
    return StreamBuilder(
        stream: chatRoomsStream,
        builder: (context, snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    return ChatRoomTile(
                        snapshot.data.docs[index]
                            .data()['chatroomId']
                            .toString()
                            .replaceAll('_', '')
                            .replaceAll(Constants.myEmail, ''),
                        snapshot.data.docs[index].data()['chatroomId']);
                  })
              : Container();
        });
  }

  @override
  void initState() {
    getUserInfo();

    super.initState();
  }

  getUserInfo() async {
    Constants.myEmail = await HelperFunctions.getUserEmailSharedPreference();
    databaseMethods.getChatRooms(Constants.myEmail).then((value) {
      setState(() {
        chatRoomsStream = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final AuthService _auth = AuthService();
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0.0,
        title: Text(
          'Welcome Back Stranger!',
          style: TextStyle(
            letterSpacing: 2.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: <Widget>[
          // ignore: deprecated_member_use
          FlatButton.icon(
            color: Colors.amber,
            onPressed: () async {
              await _auth.signOut();
            },
            icon: Icon(Icons.person),
            label: Text(
              'LogOut',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => SearchScreen()));
        },
        child: Icon(Icons.search),
      ),
      body: chatRoomList(),
    );
  }
}

class ChatRoomTile extends StatelessWidget {
  final String userEmail;
  final chatRoomId;
  ChatRoomTile(this.userEmail, this.chatRoomId);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ConversationScreen(chatRoomId)));
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[800],
          borderRadius: BorderRadius.circular(20),
        ),
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        margin: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0.0),
        child: Row(
          children: [
            Container(
              height: 50,
              width: 50,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(40),
              ),
              child: Text('${userEmail.substring(0, 1).toUpperCase()}'),
            ),
            SizedBox(width: 8),
            Text(
              userEmail,
              style: TextStyle(
                color: Colors.white,
                fontSize: 17,
              ),
            )
          ],
        ),
      ),
    );
  }
}
