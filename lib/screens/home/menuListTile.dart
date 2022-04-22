import 'package:canteen_app/models/menu_model.dart';
import 'package:canteen_app/models/user_model.dart';
import 'package:canteen_app/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MenuListTile extends StatelessWidget {
  final Menus menu;
  MenuListTile({this.menu});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 5,
      ),
      child: Card(
        child: Column(
          children: [
            ListTile(
              leading: CircleAvatar(
                radius: 30,
                backgroundImage: NetworkImage(
                  menu.imageUrl,
                ),
              ),
              title: Text(
                menu.name,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 8,
                  ),
                  Row(
                    children: [
                      Text(
                        'ItemCount: ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(menu.itemCount),
                    ],
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Row(
                    children: [
                      Text(
                        'ItemName: ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(menu.itemName),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
