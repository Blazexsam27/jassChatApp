import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:jass/helper/authenticate.dart';
import 'package:jass/helper/helperFunction.dart';
import 'package:jass/services/database.dart';
import 'package:jass/views/chatroom.dart';
import 'package:jass/views/signup.dart';
import 'package:jass/widgets/widgets.dart';
import 'package:jass/services/auth.dart';

class SignIn extends StatefulWidget {
  final Function toggle;
  SignIn(this.toggle);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  @override
    final formKey = GlobalKey<FormState>();
    bool isLoading = false;
    TextEditingController emailTextEditingController = new TextEditingController();
    TextEditingController passwordTextEditingController = new TextEditingController();
    final authMethods = new AuthMethod();
    DatabaseMethod databaseMethod = new DatabaseMethod();
    QuerySnapshot snapshotInfo;

    signMeIn() {
      if (formKey.currentState.validate()) {
        HelperFunction.saveUserEmailSharedPreference(emailTextEditingController.text);
        databaseMethod.getUserByUserEmail(emailTextEditingController.text).then((val){
          snapshotInfo = val;
          HelperFunction.saveUserNameSharedPreference(snapshotInfo.documents[0].data["name"]);
        });
        setState(() {
          isLoading = true;
        });
        
      }
      authMethods.signInWithEmailAndPassword(
          emailTextEditingController.text, passwordTextEditingController.text).then((value){
            if( value != null ){
              HelperFunction.saveUserLoggedInSharedPreference(true);
              Navigator.pushReplacement(context, MaterialPageRoute(
                  builder: (context) => ChatRoom()
              ));
            }
      });

    }


    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: appBarMain(context),
        body: isLoading ? Container(
          child: Center(child: CircularProgressIndicator(),),
        ) : SingleChildScrollView(
          child: Container(
            height: MediaQuery
                .of(context)
                .size
                .height - 50,
            alignment: Alignment.bottomCenter,
            child: Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Form(
                        key: formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              validator: (val) {
                                return RegExp(
                                    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                    .hasMatch(val) ? null : "Incorrect Email";
                              },
                              style: simpleTextStyle(),
                              decoration: textFieldDecoration("email"),
                              controller: emailTextEditingController,
                            ),
                            TextFormField(
                              validator: (val) {
                                return val.length < 5
                                    ? "Incorrect password"
                                    : null;
                              },
                              style: simpleTextStyle(),
                              obscureText: true,
                              decoration: textFieldDecoration("password"),
                              controller: passwordTextEditingController,
                            ),
                          ],
                        )
                    ),
                    SizedBox(height: 16,),
                    Container(
                        alignment: Alignment.centerRight,
                        child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 8),
                            child: Text(
                              'Forgot Password?', style: simpleTextStyle(),)
                        )
                    ),
                    SizedBox(height: 16,),
                    GestureDetector(
                      onTap: () {
                        signMeIn();
                      },
                      child: Container(
                          child: signButton(
                              context, "Sign in", 0xFF76FF03, 0xFF1DE9B6)
                      ),
                    ),
                    SizedBox(height: 16,),
                    Container(
                        child: signButton(
                            context, "Sign in with Google", 0xFFFAFAFA,
                            0xFFF5F5F5)
                    ),
                    SizedBox(height: 16,),
                    GestureDetector(
                      onTap: () {
                        widget.toggle();
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Don't have account?", style: MidTextStyle(),),
                          Text("Register now", style: TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              decoration: TextDecoration.underline),)
                        ],
                      ),
                    ),
                    SizedBox(height: 50,)
                  ],

                )
            ),
          ),
        ),
      );

  }
}
