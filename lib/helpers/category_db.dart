import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as pathPackage;
import 'package:sqflite/sqlite_api.dart';
import 'dart:io';

class DBHelper{
  static Future<Database> database()async{
    final bdPath = await sql.getDatabasesPath(); //where to sotre
    return sql.openDatabase(                      //open DB
      pathPackage.join(bdPath,'category.db'),
      onCreate: (db,version){
        db.execute('CREATE TABLE user_category(name TEXT )');
      },
      version: 1,);
  }

  static Future<void> insert(String table , Map<String , String> data ) async{
    final db = await DBHelper.database(); //get the DB and open it
    db.insert(table, data,conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<List<Map<String, dynamic>>> getData (String table) async{
    final db = await DBHelper.database(); //get the DB and open it
    return db.query(table);
  }

  static Future<void> deleteCategory(String table,String delete) async {
    final db = await DBHelper.database(); //get the DB and open it
    db.delete(
      table,
      where: "name = ?",
      whereArgs: [delete],
    );
  }

}

