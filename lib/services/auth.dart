import 'package:canteen_app/models/user_model.dart';
import 'package:canteen_app/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final String uid;
  AuthService({this.uid});
  FirebaseAuth _auth = FirebaseAuth.instance;

  //Converting Firebase user into user model
  User _getUidFromFirebaseUser(FirebaseUser user) {
    return (user != null) ? User(uid: user.uid) : null;
  }

//Setting Stream for users

  Stream<User> get user {
    return _auth.onAuthStateChanged.map((FirebaseUser user) {
      return _getUidFromFirebaseUser(user);
    });
  }

  //Registering user with email and password

  Future registerUserWithEmailAndPassword(
      String name, String email, String password) async {
    try {
      AuthResult result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser user = result.user;

      //Creating a dummy record
      await DatabaseService(uid: user.uid).updateUserRecords(
          name,
          'Not yet provided',
          '0',
          'https://static.wikia.nocookie.net/itstabletoptime/images/b/b5/Default.jpg/revision/latest?cb=20210606184459');
      return _getUidFromFirebaseUser(user);
    } catch (e) {
      print('Exception is: ${e.toString()}');
      return null;
    }
  }

  //Signing in with email and password

  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser user = result.user;
      return _getUidFromFirebaseUser(user);
    } catch (e) {
      print('Exception is: ${e.toString()}');
      return null;
    }
  }

  //SignOut
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print('Error is: ${e.toString()}');
    }
  }
}
