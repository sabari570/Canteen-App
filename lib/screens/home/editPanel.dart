import 'dart:io';
import 'package:canteen_app/models/userData_model.dart';
import 'package:canteen_app/models/user_model.dart';
import 'package:canteen_app/services/database.dart';
import 'package:canteen_app/shared/loading.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class EditPanel extends StatefulWidget {
  @override
  State<EditPanel> createState() => _EditPanelState();
}

class _EditPanelState extends State<EditPanel> {
  String currentName;
  String currentCount;
  String currentItem;
  String imageUrl;
  String getImageUrl;
  File selectedImage;
  bool isLoading = false;
  bool isProfilePicChanged = false;
  final _formKey = GlobalKey<FormState>();
  UserData userData = new UserData();

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    displaySnackBar(BuildContext context) {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text('Picture uploaded'),
        duration: Duration(seconds: 3),
      ));
    }

    return StreamBuilder<UserData>(
      stream: DatabaseService(uid: user.uid).userData,
      // ignore: missing_return
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          userData = snapshot.data;
          print('Name: ${userData.name}');
          print('ItemCount: ${userData.itemCount}');
          print('ItemName: ${userData.itemName}');
          print('ImageUrl: ${userData.imageUrl}');
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.grey[700],
              brightness: Brightness.dark,
              elevation: 0,
              automaticallyImplyLeading: false,
              title: Text('Edit your profile'),
              centerTitle: true,
            ),
            body: isLoading
                ? Loading()
                : Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(
                              'assets/canteenAppBg1.jpg',
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SingleChildScrollView(
                        child: Form(
                            key: _formKey,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 30,
                                  ),
                                  GestureDetector(
                                    onTap: () async {
                                      var image = await ImagePicker.pickImage(
                                        source: ImageSource.gallery,
                                      );
                                      setState(() {
                                        selectedImage = image;
                                      });
                                      final ref = FirebaseStorage.instance
                                          .ref()
                                          .child('UserProfiles')
                                          .child(user.uid + '.jpeg');

                                      ref.putFile(selectedImage);
                                      setState(() async {
                                        imageUrl = await ref.getDownloadURL();
                                        print(
                                            'Image uploaded and th download url is: $imageUrl');
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                                content: Text(
                                                    'Profile Pic Uploaded')));
                                      });
                                    },
                                    child: (selectedImage != null)
                                        ? Container(
                                            height: 150,
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.white,
                                              image: DecorationImage(
                                                image: FileImage(
                                                  selectedImage,
                                                ),
                                                fit: BoxFit.contain,
                                              ),
                                            ),
                                          )
                                        : Container(
                                            height: 150,
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.white,
                                              image: DecorationImage(
                                                image: NetworkImage(
                                                  userData.imageUrl,
                                                ),
                                              ),
                                            ),
                                            alignment: Alignment.center,
                                            child: Icon(Icons.add_a_photo),
                                          ),
                                  ),
                                  SizedBox(
                                    height: 30,
                                  ),
                                  TextFormField(
                                    initialValue: currentName ?? userData.name,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    validator: (val) => val.isEmpty
                                        ? 'Please enter your name'
                                        : null,
                                    onChanged: (val) {
                                      setState(() {
                                        currentName = val;
                                      });
                                    },
                                    decoration: InputDecoration(
                                      hintText: 'Name',
                                      hintStyle: TextStyle(
                                        color: Colors.white54,
                                      ),
                                      labelText: 'Name',
                                      labelStyle: TextStyle(
                                        color: Colors.white54,
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
                                        borderSide: BorderSide(
                                          color: Colors.white54,
                                          width: 2,
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
                                        borderSide: BorderSide(
                                          color: Colors.white,
                                          width: 5,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 30,
                                  ),
                                  TextFormField(
                                    initialValue:
                                        currentCount ?? userData.itemCount,
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                    validator: (val) => val.isEmpty
                                        ? 'Enter the itemCount'
                                        : null,
                                    onChanged: (val) {
                                      setState(() {
                                        currentCount = val;
                                      });
                                    },
                                    decoration: InputDecoration(
                                      hintText: 'ItemCount',
                                      hintStyle: TextStyle(
                                        color: Colors.white54,
                                      ),
                                      labelText: 'ItemCount',
                                      labelStyle: TextStyle(
                                        color: Colors.white54,
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
                                        borderSide: BorderSide(
                                          color: Colors.white54,
                                          width: 2,
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
                                        borderSide: BorderSide(
                                          color: Colors.white,
                                          width: 5,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 30,
                                  ),
                                  TextFormField(
                                    initialValue:
                                        currentItem ?? userData.itemName,
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                    validator: (val) => val.isEmpty
                                        ? 'Enter the itemName'
                                        : null,
                                    onChanged: (val) {
                                      setState(() {
                                        currentItem = val;
                                      });
                                    },
                                    decoration: InputDecoration(
                                      hintText: 'ItemName',
                                      hintStyle: TextStyle(
                                        color: Colors.white54,
                                      ),
                                      labelText: 'ItemName',
                                      labelStyle: TextStyle(
                                        color: Colors.white54,
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
                                        borderSide: BorderSide(
                                          color: Colors.white54,
                                          width: 2,
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
                                        borderSide: BorderSide(
                                          color: Colors.white,
                                          width: 5,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 60,
                                  ),
                                  GestureDetector(
                                    onTap: () async {
                                      if (_formKey.currentState.validate()) {
                                        await DatabaseService(uid: user.uid)
                                            .updateUserRecords(
                                          currentName ?? userData.name,
                                          currentItem ?? userData.itemName,
                                          currentCount ?? userData.itemCount,
                                          imageUrl ?? userData.imageUrl,
                                        );

                                        Navigator.pop(context);
                                      }
                                    },
                                    child: Container(
                                      height: 50,
                                      width: MediaQuery.of(context).size.width,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: Colors.grey[900],
                                      ),
                                      alignment: Alignment.center,
                                      child: Text(
                                        'Update',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 17,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )),
                      )
                    ],
                  ),
          );
        } else {
          Loading();
        }
      },
    );
  }
}
