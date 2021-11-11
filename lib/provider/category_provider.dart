// ignore_for_file: unnecessary_string_interpolations

import 'package:flutter/material.dart';
import 'package:idea_hunter/helpers/category_db.dart';

class IdeaCategory extends ChangeNotifier {
  final List<String> _categoryNames = <String>[
    'General',
    'Video',
    'App',
    'Note',
    'Post Idea',
    'Story Idea',
  ];
bool isDataHere = false;
String? defaultCategoryNames = 'General'; // this is the default category save location

  //return map of _categoryNames list for sqflite
  Map<String, String> convertList2Map(){
   return {
      for(var item in _categoryNames ) 'name': '$item'
  };
  }

  void addCategory(String categoryName) {
    _categoryNames.add(categoryName);
    DBHelper.insert('user_category',convertList2Map() );
    notifyListeners();
  }
  void deleteCategory(String categoryName) {
    _categoryNames.remove(categoryName);
    DBHelper.deleteCategory('user_category',categoryName );
    notifyListeners();
  }


  Future<List<String>> getDataFromDB() async {
    final dbList = await DBHelper.getData('user_category');
    isDataHere = true;
    return dbList.map((e) => e['name']).toList().cast<String>();
  }



  Future<List<String>> getCategoryNames2() async {

     getDataFromDB().then((value) {
      bool isExist(String valueName) => _categoryNames.contains(valueName);
      for(int i=0 ; i < value.length ;i++){
        if (!isExist(value[i])){
          _categoryNames.add(value[i]);
        }
      }

    });
    return _categoryNames;
  }

  List<String> getCategoryNames() {
     getDataFromDB().then((value) {
     bool isExist(String valueName) => _categoryNames.contains(valueName);
     for(int i=0 ; i < value.length ;i++){
       if (!isExist(value[i])){
         _categoryNames.add(value[i]);
       }

     }

   });

   print(_categoryNames);
   print(isDataHere);
   //notifyListeners();
    return _categoryNames;
  }




}
