import 'package:flutter/material.dart';
import 'package:jass/helper/helperFunction.dart';
import 'package:jass/views/chatroom.dart';
import 'package:jass/views/signin.dart';
import 'package:jass/views/signup.dart';

import 'helper/authenticate.dart';

void main() => runApp(MyApp());
class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  HelperFunction helperFunction = new HelperFunction();
  bool userLoggedInState = false;
  @override
  void initState(){
    getLoggedInState();
    super.initState();
  }

  getLoggedInState() async{
    await helperFunction.getUserLoggedInSharedPreference().then((value){
      setState(() {
        if( value != null ){
          userLoggedInState = value;
        }
      });
    });
  }

  Widget build(BuildContext context) {
    return MaterialApp(
      title:"JASS Chat",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          scaffoldBackgroundColor: Colors.black54
      ),
      home: userLoggedInState ? ChatRoom() : Authenticate(),
    );
  }
}
