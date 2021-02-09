import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jass/helper/constants.dart';
import 'package:jass/services/database.dart';
import 'package:jass/widgets/widgets.dart';

class ConversationScreen extends StatefulWidget {
  String chatRoomId;
  ConversationScreen(this.chatRoomId);
  @override
  _ConversationScreenState createState() => _ConversationScreenState();
  ScrollController _scrollController = new ScrollController();
  _scrollToBottom(){
    _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
  }
}

class _ConversationScreenState extends State<ConversationScreen> {

  DatabaseMethod databaseMethod = new DatabaseMethod();
  TextEditingController messageController = new TextEditingController();
  Stream chatMessageStream;

  Widget chatMessageList(){
    return StreamBuilder(
      stream: chatMessageStream,
      builder: (context, snapshot){
        return snapshot.hasData ? ListView.builder(
          controller: widget._scrollController,
            itemCount: snapshot.data.documents.length,
            itemBuilder: (context, index){
              return MessageTile(snapshot.data.documents[index].data["message"],
                  snapshot.data.documents[index].data["sendBy"] == Constant.myName
              );
            }) : Container();
      },
    );
  }

  @override
  void initState(){
    databaseMethod.getConversationMessages(widget.chatRoomId).then((value){
      setState(() {
        chatMessageStream = value;
      });
    });
    super.initState();
  }

  sendMessage(){
    if( messageController.text.isNotEmpty )
    {
      Map<String, dynamic> messageMap = {
        "message": messageController.text,
        "sendBy" : Constant.myName,
        "time" : DateTime.now().millisecondsSinceEpoch,
      };
      databaseMethod.addConversationMessages(widget.chatRoomId, messageMap);
      messageController.text = "";
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: Container(
        child: Stack(
          children: <Widget>[
            chatMessageList(),
            Container(
              alignment: Alignment.bottomCenter,
              child: Container(
                color:Color(0x54FFFFFF),
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          style: TextStyle(
                              color: Colors.white
                          ),
                          controller: messageController,
                          decoration: InputDecoration(
                              hintText: "Message...",
                              hintStyle: TextStyle(
                                  color: Colors.white54
                              ),
                              border: InputBorder.none
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          sendMessage();
                          widget._scrollToBottom();
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
                            child: Image.asset("assets/images/send.png", color: Colors.white,)
                        ),
                      )
                    ]
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class MessageTile extends StatelessWidget {

  final String message;
  final bool isSendByMe;
  MessageTile(this.message, this.isSendByMe);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: isSendByMe ? 0 : 24, right: isSendByMe ? 24 : 0),
      margin: EdgeInsets.symmetric(vertical:8),
      width: MediaQuery.of(context).size.width,
      alignment: isSendByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isSendByMe ? [
              const Color(0xff007EF4),
              const Color(0xff2A75BC)
            ] : [
              const Color(0x1AFFFFFF),
              const Color(0x1AFFFFFF)
            ]
          ),
          borderRadius: isSendByMe ? BorderRadius.only(
            topRight: Radius.circular(23),
            topLeft: Radius.circular(23),
            bottomLeft: Radius.circular(23)
          ) : BorderRadius.only(
              topRight: Radius.circular(23),
              topLeft: Radius.circular(23),
              bottomRight: Radius.circular(23)
          )
        ),
        child: Text(message, style: TextStyle(
            color: Colors.white, fontSize: 17
        )),
      ),
    );
  }
}

