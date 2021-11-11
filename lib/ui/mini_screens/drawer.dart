import 'package:flutter/material.dart';
import 'package:idea_hunter/constants/size.dart';

Widget? myDrawer(BuildContext context){
  return Drawer(
    child: Container(
      color: const Color(0xFFffda11),
      child: ListView(
        padding: const EdgeInsets.symmetric(vertical: 100 ,horizontal: 10),
        children: [
          ListTile(
            title: Text(
              'Contact me ',
              style: kDrawerListTileStyle,
              textAlign: TextAlign.left,
            ),
            onTap: () {
              Navigator.pop(context);

            },
          ),
          ListTile(
            title: Text(
              'Remove Ads',
              style: kDrawerListTileStyle,
              textAlign: TextAlign.left,
            ),
            onTap: () {
              print('About pressed');
            },
          ),
          ListTile(
            title: Text(
              'About',
              style: kDrawerListTileStyle,
              textAlign: TextAlign.left,
            ),
            onTap: () {
              print('About pressed');
            },
          ),
        ],
      ),
    ),
  );
}