import 'package:canteen_app/models/menu_model.dart';
import 'package:canteen_app/screens/home/menuListTile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MenuTile extends StatefulWidget {
  @override
  State<MenuTile> createState() => _MenuTileState();
}

class _MenuTileState extends State<MenuTile> {
  @override
  Widget build(BuildContext context) {
    final menus = Provider.of<List<Menus>>(context) ?? [];
    return ListView.builder(
      itemCount: menus.length,
      itemBuilder: (context, index) {
        return MenuListTile(
          menu: menus[index],
        );
      },
    );
  }
}
