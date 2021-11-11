// ignore_for_file: unnecessary_string_interpolations

import 'dart:io';
import 'package:flutter/material.dart';


class GetIdeas extends ChangeNotifier  {
  late Directory? ideaHunterDirectory;
  late Directory? ideaHunterDirectory2;
  List<String> ideas = [];

  void setIdeaHunterDirectory(Directory? value){
  ideaHunterDirectory = value;
  print('setIdeaHunterDirectory is $ideaHunterDirectory');
  }

  Future<List<String>> initIdeas2(String categoryName) async{
    var ideas2 = initIdeas(categoryName);
    return ideas2;
  }
  List<String> initIdeas (String categoryName) {
    String folderPath = "";
    List<String> subFolders = ideaHunterDirectory!.path.split("/");
    for (int x = 1; x < subFolders.length; x++) {
      String folder = subFolders[x];
      if (folder != "Android") {
        folderPath += "/" + folder;
      } else {
        break;
      }
    }
    // Here we can choose storage location by category
    folderPath = folderPath + "/Idea Hunter/$categoryName";
    //folderPath = folderPath + "/Idea Hunter/$defaultCategoryNames";
    ideaHunterDirectory2 = Directory(folderPath);
    ideas.clear();
    ideaHunterDirectory2!.list().listen((onData) {
      if (onData.path.contains('.aac')) ideas.add(onData.path);
    }).onDone(() {
      ideas.sort();
      ideas = ideas.toList();
      //setState(() {});
    });
    return ideas;
  }

  onRecordComplete() {
    ideas.clear();
    ideaHunterDirectory!.list().listen((onData) {
      if (onData.path.contains('.aac')) ideas.add(onData.path);
    }).onDone(() {
      ideas.sort();
      ideas = ideas.toList();

      //setState(() {});
    });
  }

}