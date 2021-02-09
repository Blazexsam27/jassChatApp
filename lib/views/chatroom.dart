import 'package:flutter/material.dart';
import 'package:jass/helper/authenticate.dart';
import 'package:jass/helper/constants.dart';
import 'package:jass/helper/helperFunction.dart';
import 'package:jass/services/auth.dart';
import 'package:jass/services/database.dart';
import 'package:jass/views/ConversationScreen.dart';
import 'package:jass/views/search.dart';
import 'package:jass/views/signin.dart';
import 'package:jass/widgets/widgets.dart';

class ChatRoom extends StatefulWidget {

  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  String _myName;
  Stream chatRoomStream;
  HelperFunction helperFunction = new HelperFunction();
  final authMethod = new AuthMethod();
  DatabaseMethod databaseMethod = new DatabaseMethod();

  Widget chatRoomList(){
    return StreamBuilder(
      stream: chatRoomStream,
      builder: (context, snapshot){
        return snapshot.hasData ? ListView.builder(
            itemCount: snapshot.data.documents.length,
            itemBuilder: (context, index){
              return ChatRoomTile(
                snapshot.data.documents[index].data["chatRoomId"].toString().replaceAll("_", "").replaceAll(Constant.myName, ""),
                  snapshot.data.documents[index].data["chatRoomId"]
              );
            }) : Container();
      },
    );
  }

  @override
  void initState() {
    getUserInfo();
    super.initState();
  }

  getUserInfo() async{
    Constant.myName = await helperFunction.getUserNameSharedPreference();
    databaseMethod.getChatRooms(Constant.myName).then((value){
      setState(() {
        chatRoomStream = value;
      });
    });
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Image.asset("assets/images/jasschat.png", height: 60),
        actions: [
          GestureDetector(
            onTap: (){
              authMethod.signOut();
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Authenticate()));
            },
            child: Container(
                padding: EdgeInsets.symmetric(horizontal:16),
                child: Icon(Icons.exit_to_app)),
          )
        ],
      ),
      body: chatRoomList(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.search),
            onPressed: (){
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SearchScreen()));
            },
      ),
    );
  }
}

class ChatRoomTile extends StatelessWidget {
  final String username;
  final String chatRoomId;
  ChatRoomTile(this.username, this.chatRoomId);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(
          context, MaterialPageRoute(
          builder: (context) => ConversationScreen(chatRoomId)
        )
        );
      },
      child: Container(
        color: Colors.black12,
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Row(
          children: <Widget>[
            Container(
              height: 45,
              width: 45,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.blue
              ),
              child: Text("${username.substring(0, 1).toUpperCase()}", style: MidTextStyle(),),
            ),
            SizedBox(width: 8,),
            Text(username, style: MidTextStyle(),)
          ],
        ),
      ),
    );
  }
}


