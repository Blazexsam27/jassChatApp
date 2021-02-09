import 'package:flutter/material.dart';
import 'package:jass/helper/helperFunction.dart';
import 'package:jass/services/database.dart';
import 'package:jass/views/chatroom.dart';
import 'package:jass/views/signin.dart';
import 'package:jass/widgets/widgets.dart';
import 'package:jass/services/auth.dart';

class SignUp extends StatefulWidget {
  final Function toggle;
  SignUp(this.toggle);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {

  TextEditingController usernameTextEditingController = new TextEditingController();
  TextEditingController emailTextEditingController = new TextEditingController();
  TextEditingController passwordTextEditingController = new TextEditingController();
  final authMethod = new AuthMethod();
  final databaseMethod = new DatabaseMethod();
  final formKey = GlobalKey<FormState>();
  bool isLoading = false;

  signMeUp(){
    Map<String, String> userInfoMap;
    if(formKey.currentState.validate()) {
      userInfoMap = {
        "name": usernameTextEditingController.text,
        "email": emailTextEditingController.text
      };

      HelperFunction.saveUserEmailSharedPreference(emailTextEditingController.text);
      HelperFunction.saveUserNameSharedPreference(usernameTextEditingController.text);
      setState(() {
        isLoading = true;
      });
    }
      print(emailTextEditingController.text);
      authMethod.signUpWithEmailAndPassword(emailTextEditingController.text, passwordTextEditingController.text);
      databaseMethod.uploadUserInfo(userInfoMap);
      HelperFunction.saveUserLoggedInSharedPreference(true);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ChatRoom()));

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: isLoading ? Container(child : Center(child: CircularProgressIndicator(),)):
      SingleChildScrollView(
        child:Container(
          height: MediaQuery.of(context).size.height - 50,
          alignment: Alignment.bottomCenter,
          child: Container(
            margin:EdgeInsets.symmetric(horizontal: 20),
            child:Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Form(
                  key:formKey,
                  child:
                    Column(
                      children: <Widget>[
                        TextFormField(
                          validator: (value){
                            return value.isEmpty || value.length < 2 ? "Username is too Short" : null;
                          },
                          controller: usernameTextEditingController,
                          style: simpleTextStyle(),
                          decoration: textFieldDecoration("username"),
                        ),
                        TextFormField(
                          validator: (value){
                            return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch((value)) ? null : "Invalid Email id";
                          },
                          controller: emailTextEditingController,
                          style: simpleTextStyle(),
                          decoration: textFieldDecoration("Email"),
                        ),
                        TextFormField(
                          validator: (value){
                            return value.length < 3 ? "Password too short" : null;
                          },
                          controller: passwordTextEditingController,
                          style: simpleTextStyle(),
                          obscureText: true,
                          decoration: textFieldDecoration("Password"),
                        )
                      ],
                    )
                ),
                SizedBox(height: 16,),
                Container(
                  alignment: Alignment.centerRight,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    child: Text('Forgot Password?', style: simpleTextStyle()),
                  ),
                ),
                SizedBox(height: 16,),
                GestureDetector(
                  onTap: (){
                    signMeUp();
                  },
                  child: Container(
                    child: signButton(context, "Sign up", 0xFF76FF03, 0xFF1DE9B6)
                  ),
                ),
                SizedBox(height: 16,),
                Container(
                    child: signButton(context, "Sign up with Google", 0xFFFAFAFA, 0xFFF5F5F5)
                ),
                SizedBox(height:16,),
                GestureDetector(
                  onTap: (){
                    widget.toggle();
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Already have account?", style: MidTextStyle(),),
                      Text("Sign in", style: TextStyle(color: Colors.white, fontSize: 17, decoration: TextDecoration.underline),)
                    ],
                  ),
                ),
                SizedBox(height: 60,)
              ],
            )
          ),
        )
      ),
    );
  }
}

