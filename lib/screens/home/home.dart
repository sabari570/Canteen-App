import 'package:canteen_app/models/menu_model.dart';
import 'package:canteen_app/models/user_model.dart';
import 'package:canteen_app/screens/home/editPanel.dart';
import 'package:canteen_app/screens/home/menusTile.dart';
import 'package:canteen_app/services/auth.dart';
import 'package:canteen_app/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isEditable = true;
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    return StreamProvider<List<Menus>>.value(
      value: DatabaseService().menus,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.grey[700],
          brightness: Brightness.dark,
          elevation: 0,
          title: Row(
            children: [
              Text(
                'Crew',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'List',
                style: TextStyle(
                  color: Colors.yellow,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          actions: [
            FlatButton.icon(
              onPressed: isEditable
                  ? () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return EditPanel();
                      }));
                    }
                  : () {},
              icon: Icon(
                Icons.edit,
                color: Colors.white,
              ),
              label: Text(
                'Edit',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            FlatButton.icon(
              onPressed: () async {
                await DatabaseService(uid: user.uid).deleteRecordAfterUse();
                setState(() {
                  isEditable = false;
                });
              },
              icon: Icon(
                Icons.delete,
                color: Colors.white,
              ),
              label: Text(
                'Remove',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            FlatButton.icon(
              onPressed: () async {
                await AuthService().signOut();
              },
              icon: Icon(
                Icons.exit_to_app,
                color: Colors.white,
              ),
              label: Text(
                'Logout',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        body: Stack(
          children: [
            Container(
                decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  'assets/canteenAppBg1.jpg',
                ),
                fit: BoxFit.cover,
              ),
            )),
            MenuTile(),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            await DatabaseService(uid: user.uid).updateUserRecords(
                'New Member',
                'Not yet provided',
                '0',
                'https://static.wikia.nocookie.net/itstabletoptime/images/b/b5/Default.jpg/revision/latest?cb=20210606184459');
            setState(() {
              isEditable = true;
            });
          },
          child: Icon(Icons.add),
          backgroundColor: Colors.grey[800],
        ),
      ),
    );
  }
}
