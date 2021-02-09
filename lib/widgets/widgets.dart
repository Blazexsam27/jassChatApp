import 'package:flutter/material.dart';

Widget appBarMain(BuildContext context){
  return AppBar(
    title: Image.asset("assets/images/jasschat.png",
    height: 80),
  );
}

InputDecoration textFieldDecoration(String hintString){
  return InputDecoration(
    hintText: hintString,
    hintStyle: TextStyle(color: Colors.white54),
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.blueAccent),
    ),
      enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color:Colors.white))
  );
}

TextStyle simpleTextStyle(){
  return TextStyle(
    color: Colors.white, fontSize: 16
  );
}

TextStyle MidTextStyle(){
  return TextStyle(
      color: Colors.white, fontSize: 17
  );
}

Container signButton(BuildContext context, String text, int color1, int color2){
  return Container(
      padding: EdgeInsets.symmetric(vertical: 18),
      alignment: Alignment.center,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          gradient: LinearGradient(
              colors:[Color(color1), Color(color2)]
          ),
          borderRadius: BorderRadius.circular(27)
      ),
      child:Text(text, style: TextStyle(color:Colors.black, fontSize: 16),)
  );
}
