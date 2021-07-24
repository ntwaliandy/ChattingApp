import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  getUserByEmail(String email) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .where("email", isEqualTo: email)
        .get();
  }

  uploadUserInfo(userMap) {
    FirebaseFirestore.instance.collection("users").add(userMap).catchError((e) {
      print(e.toString());
    });
  }

  createChatRoom(String chatRoomId, chatRoomMap) {
    FirebaseFirestore.instance
        .collection("ChatRoom")
        .doc(chatRoomId)
        .set(chatRoomMap)
        .catchError((e) {
      print(e.toString());
    });
  }

  addConversationMessages(String chatRoomId, messageMap) {
    FirebaseFirestore.instance
        .collection('ChatRoom')
        .doc(chatRoomId)
        .collection('chats')
        .add(messageMap)
        .catchError((e) {
      print(e.toString());
    });
  }

  getConversationMessages(String chatRoomId) async {
    // ignore: await_only_futures
    return await FirebaseFirestore.instance
        .collection('ChatRoom')
        .doc(chatRoomId)
        .collection('chats')
        .orderBy('time', descending: false)
        .snapshots();
  }

  // ignore: non_constant_identifier_names
  getChatRooms(String UserEmail) async {
    // ignore: await_only_futures
    return await FirebaseFirestore.instance
        .collection('ChatRoom')
        .where('users', arrayContains: UserEmail)
        .snapshots();
  }
}
