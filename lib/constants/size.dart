import 'package:flutter/material.dart';
//This is Constant values for all Project
String kNoName = 'noName';

TextStyle kSaveButtonStyle = const TextStyle(
    color: Colors.black87, fontSize: 18, fontWeight: FontWeight.w600);

TextStyle kDiscardButtonStyle = const TextStyle(
    color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500);

TextStyle kHintStyle = const TextStyle(
    color: Colors.white, fontSize: 16, fontWeight: FontWeight.w400);

TextStyle kTextInputStyle = const TextStyle(
    color: Colors.white, fontSize: 18, fontWeight: FontWeight.w500);
TextStyle kSnackBarStyle =
    const TextStyle(color: Colors.black87, fontWeight: FontWeight.w600);

TextStyle kDrawerListTileStyle = const TextStyle(
color: Colors.black87, fontSize: 20, fontWeight: FontWeight.w900);


// MySnakeBar
SnackBar customSnackBar(String text, BuildContext context) {
  return SnackBar(
    action: SnackBarAction(
        label: 'Done',
        textColor: Colors.black87,
        onPressed: () {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
        }),
    duration: const Duration(milliseconds: 2000),
    content: Text(
      text,
      style: kSnackBarStyle,
    ),
    behavior: SnackBarBehavior.floating,
    margin: const EdgeInsets.symmetric(horizontal: 35, vertical: 15),
    backgroundColor: Colors.yellow,
    elevation: 6.0,
    dismissDirection: DismissDirection.horizontal,
  );
}

void showMySnackBar(String text, BuildContext context) {
  ScaffoldMessenger.of(context).hideCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(
    customSnackBar(text, context),
  );
}
