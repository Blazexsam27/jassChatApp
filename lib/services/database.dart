import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethod{
  getUserByUsername(String username) async{
    return await Firestore.instance.collection("users").where("name", isEqualTo: username).getDocuments();
  }

  getUserByUserEmail(String userEmail) async{
    return await Firestore.instance.collection("users").where("email", isEqualTo: userEmail).getDocuments();
  }

  uploadUserInfo(userMap){
    Firestore.instance.collection("users").add(userMap).catchError((e){
      print(e.toString());
    });
  }
  
  createChatRoom(String chatRoomId, chatRoomMap){
    print("Ban gaya chat room");
    Firestore.instance.collection("ChatRoom").document(chatRoomId).setData(chatRoomMap).catchError((e){print(e.toString());});
  }

  getConversationMessages(String chatRoomId) async{
    return await Firestore.instance.collection("ChatRoom").document(chatRoomId).collection("chats").orderBy("time", descending: false).snapshots();
  }

  addConversationMessages(String chatRoomId, messageMap){
    Firestore.instance.collection("ChatRoom").document(chatRoomId).collection("chats").add(messageMap).catchError((e){print(e.toString());});
  }

  getChatRooms(String username) async{
    return await Firestore.instance.collection("ChatRoom").where("users", arrayContains: username).snapshots();
  }

}