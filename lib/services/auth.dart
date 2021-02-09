import 'package:firebase_auth/firebase_auth.dart';
import 'package:jass/modal/user.dart';

class AuthMethod{
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Userx _userFromFirebase(FirebaseUser user){
    return user != null ? Userx(userId: user.uid) : null;
  }

  Future signInWithEmailAndPassword(String email, String password) async{
    try{
        AuthResult result = await _auth.signInWithEmailAndPassword(email: email, password: password);
        FirebaseUser firebaseUser = result.user;
        return _userFromFirebase(firebaseUser);
    }catch(e){
      print(e.toString());
    }
  }

  Future signUpWithEmailAndPassword(String email, String password) async{
    try{
      AuthResult result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      FirebaseUser firebaseUser = result.user;
      return _userFromFirebase(firebaseUser);
    }catch(e){
      print("Yeh Hai Error: " + e.toString());
    }
  }

  Future resetPassword(String email) async{
    try{
      return await _auth.sendPasswordResetEmail(email: email);
    }catch(e){
      print(e.toString());
    }
  }

  Future signOut() async{
      return await _auth.signOut();
  }
}