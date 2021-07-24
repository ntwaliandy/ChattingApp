//@dart=2.9

import 'package:chatapp_draft/screens/ChatRoom.dart';
import 'package:chatapp_draft/services/constant.dart';
import 'package:chatapp_draft/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  DatabaseMethods databaseMethods = new DatabaseMethods();
  TextEditingController searchTextEdittingController =
      new TextEditingController();
  QuerySnapshot searchSnapshot;

  Widget searchList() {
    return searchSnapshot != null
        ? ListView.builder(
            itemCount: searchSnapshot.docs.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return SearchTile(
                Email: searchSnapshot.docChanges[index].doc["email"],
              );
            })
        : Text('No user Found');
  }

  initiateSearch() {
    databaseMethods
        .getUserByEmail(searchTextEdittingController.text)
        .then((val) {
      setState(() {
        searchSnapshot = val;
      });
    });
  }

  /// create chatroom, sends user to conversation screen, pushreplacement
  createChatroomAndStartConversation({String userEmail, myEmail}) {
    if (userEmail != Constants.myEmail) {
      String chatRoomId = getChatRoomId(userEmail, Constants.myEmail);
      List<String> users = [userEmail, Constants.myEmail];
      Map<String, dynamic> charRoomMap = {
        "users": users,
        "chatroomId": chatRoomId,
      };

      DatabaseMethods().createChatRoom(chatRoomId, charRoomMap);
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ConversationScreen(chatRoomId),
          ));
      print(userEmail);
      print(Constants.myEmail);
    } else {
      print("you can't text yourself please!");
    }
  }

// ignore: non_constant_identifier_names
  Widget SearchTile({String Email}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          Text(
            Email,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              letterSpacing: 2.0,
            ),
          ),
          Spacer(),
          GestureDetector(
            onTap: () {
              createChatroomAndStartConversation(
                userEmail: Email,
              );
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(30),
              ),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Text(
                'Message',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    initiateSearch();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        elevation: 0.0,
        title: Text(
          'Exclusive App',
          style: TextStyle(
            letterSpacing: 2.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Container(
        color: Colors.black,
        child: Column(
          children: [
            Container(
              color: Color(0x54FFFFFF),
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: searchTextEdittingController,
                      style: TextStyle(
                        letterSpacing: 2.0,
                        color: Colors.white,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Search By Email.....',
                        hintStyle: TextStyle(
                          color: Colors.white54,
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      initiateSearch();
                    },
                    child: Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                          gradient: LinearGradient(colors: [
                            const Color(0x36FFFFFF),
                            const Color(0x0FFFFFFF),
                          ]),
                          borderRadius: BorderRadius.circular(40)),
                      padding: EdgeInsets.all(7),
                      child: Icon(Icons.search),
                    ),
                  ),
                ],
              ),
            ),
            searchList(),
          ],
        ),
      ),
    );
  }
}

getChatRoomId(String a, String b) {
  if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
    return "$b\_$a";
  } else {
    return "$a\_$b";
  }
}
