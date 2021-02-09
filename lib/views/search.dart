import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jass/helper/constants.dart';
import 'package:jass/helper/helperFunction.dart';
import 'package:jass/services/database.dart';
import 'package:jass/views/ConversationScreen.dart';
import 'package:jass/widgets/widgets.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}
String _myName;
class _SearchScreenState extends State<SearchScreen> {

  TextEditingController searchTextEditingController = new TextEditingController();
  final databaseMethod = new DatabaseMethod();
  QuerySnapshot searchSnapshot;
  HelperFunction helperFunction = new HelperFunction();

  initiateSearch(){
    databaseMethod.getUserByUsername(searchTextEditingController.text).then((value){
      setState(() {
        searchSnapshot = value;
      });
    });
  }

  getChatRoomId(String a, String b){
    print(a);
    print(b);
    if(a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)){
      return "$a\_$b";
    }
    else
      return "$b\_$a";
  }

  @override
  void initState(){
    getUserInfo();
    super.initState();
  }

  getUserInfo() async{
    Constant.myName = await helperFunction.getUserNameSharedPreference();
    setState(() {

    });
    print(Constant.myName + " Ye rha tumhara naam!");
  }

  createChatRoomAndStartConversation({String username}){
    if(username != Constant.myName){
      String chatRoomId = getChatRoomId(username, Constant.myName);
      print(chatRoomId);
      List<String> users = [username, Constant.myName];
      Map<String, dynamic> chatRoomMap = {
        "users": users,
        "chatRoomId" : chatRoomId
      };

      databaseMethod.createChatRoom(chatRoomId, chatRoomMap);
      Navigator.push(context, MaterialPageRoute(
          builder: (context) => ConversationScreen(chatRoomId)
      ));
    }else
      {
        print("pehli fursat mein nikal!");
      }
  }

  Widget searchTile({String userName, String userEmail}){
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(userName, style: MidTextStyle(),),
                Text(userEmail, style: MidTextStyle())
              ],
            ),
            Spacer(),
            GestureDetector(
              onTap: () {
                print("pressed!");
                createChatRoomAndStartConversation(username: userName);
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(25)
                ),
                child: Text("Message", style: MidTextStyle(),),

              ),
            )

          ],
        )
    );
  }

  Widget searchList(){
    return searchSnapshot != null ? ListView.builder(
        itemCount: searchSnapshot.documents.length,
        shrinkWrap: true,
        itemBuilder: (context, index){
          return searchTile(
            userName: searchSnapshot.documents[index].data["name"],
            userEmail: searchSnapshot.documents[index].data["email"]
          );
        }) : Container(
      child: Text("Nothing Found!")
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: Container(
        child: Column(

          children:[
            Container(
              color:Color(0x54FFFFFF),
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      style: TextStyle(
                        color: Colors.white
                      ),
                      controller: searchTextEditingController,
                      decoration: InputDecoration(
                        hintText: "search username...",
                        hintStyle: TextStyle(
                          color: Colors.white54
                        ),
                        border: InputBorder.none
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
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              const Color(0x36FFFFFF),
                              const Color(0x0FFFFFFF)
                            ]
                          ),
                          borderRadius: BorderRadius.circular(40)
                        ),
                        child: Image.asset("assets/images/search_png.png", color: Colors.white,)
                    ),
                  )
                ]
              ),
            ),
            searchList()
          ],
        )
      )
    );
  }
}


