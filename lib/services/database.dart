import 'package:canteen_app/models/menu_model.dart';
import 'package:canteen_app/models/userData_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String uid;
  DatabaseService({this.uid});

  //Creating a collection reference
  CollectionReference menusCollection = Firestore.instance.collection('menus');
  //Converting snapshots to list of menus
  List<Menus> gettingMenusList(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return Menus(
          name: doc.data['name'] ?? '',
          itemCount: doc.data['itemCount'] ?? '0',
          itemName: doc.data['itemName'] ?? '',
          imageUrl: doc.data['imageUrl'] ?? 'assets/defaultDP.jpg');
    }).toList();
  }

  //Passing Streams
  Stream<List<Menus>> get menus {
    return menusCollection
        .snapshots()
        .map((QuerySnapshot snapshot) => gettingMenusList(snapshot));
  }

//Getting userData stream
  UserData gettingUserDataRecords(DocumentSnapshot snapshot) {
    return UserData(
      uid: uid,
      name: snapshot.data['name'],
      itemCount: snapshot.data['itemCount'],
      itemName: snapshot.data['itemName'],
      imageUrl: snapshot.data['imageUrl'],
    );
  }

  Stream<UserData> get userData {
    return menusCollection
        .document(uid)
        .snapshots()
        .map((DocumentSnapshot snapshot) => gettingUserDataRecords(snapshot));
  }

  //Updating user record
  Future updateUserRecords(
      String name, String itemName, String itemCount, String imageUrl) async {
    try {
      return await menusCollection.document(uid).setData({
        'name': name,
        'itemCount': itemCount,
        'itemName': itemName,
        'imageUrl': imageUrl,
      });
    } catch (e) {
      print('Error is: ${e.toString()}');
      return null;
    }
  }

  //Deleting a document after use

  Future deleteRecordAfterUse() async {
    try {
      await menusCollection.document(uid).delete();
    } catch (e) {
      print('Error is: ${e.toString()}');
    }
  }
}
