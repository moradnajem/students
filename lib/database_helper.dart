import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';



class DatabaseHelper {

  /// DataBase Naem and Version
  static final _databaseName = "mydb.db";
  static final _databaseVersion = 1;


  /// Table1
  static final table1 = 'students'; // table1 name
  static final studentsId = 'id';
  static final studentsName = 'name';
  static final studentsStage = 'stage';

  /// Table2
  static final table2 = 'classes'; // table2 name
  static final classesId = 'id';
  static final classesName = 'name';
  static final classesStage = 'stage';
  static final classesDecryption = 'decryption';


  /// Table3
  static final table3 = 'classes_students'; // table3 name
  static final id = 'id';
  static final students_id = 'students_id';
  static final classes_id = 'classes_id';



  /// make this a singleton class
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();



  static Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }




  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion,
        onCreate: _onCreate);
  }




  Future _onCreate(Database db, int version) async {


    await db.execute('''
          CREATE TABLE IF NOT EXISTS $table1 (
            $studentsId INTEGER PRIMARY KEY,
            $studentsName TEXT NOT NULL,
            $studentsStage TEXT NOT NULL
           )
          ''');

    await db.execute('''
          CREATE TABLE IF NOT EXISTS $table2 (
            $classesId INTEGER PRIMARY KEY,
            $classesName TEXT NOT NULL,
            $classesStage TEXT NOT NULL,
            $classesDecryption TEXT NOT NULL
           )
          ''');

    await db.execute('''
          CREATE TABLE IF NOT EXISTS $table3 (
            $id INTEGER PRIMARY KEY,
            $students_id INTEGER NOT NULL,
            $classes_id INTEGER NOT NULL
           )
          ''');
  }
















  /// STUDENTS


  Future insertToStudents(Map<String, dynamic> map) async{
    Database db = await instance.database;
    await db.insert('students', map);
  }

  Future getAllStudents() async{
    Database db = await instance.database;
    var result = await db.rawQuery('select * from students');
    return result;
  }


  Future deleteStudents({id}) async{
    Database db = await instance.database;
    await db.rawQuery('delete from students where id = $id');
  }




  /// CLASSES


  Future insertToClasses(Map<String, dynamic> map) async{
    Database db = await instance.database;
    await db.insert('classes', map);
  }

  Future getAllClasses() async{
    Database db = await instance.database;
    var result = await db.rawQuery('select * from classes');
    return result;
  }


  Future deleteClasses({id}) async{
    Database db = await instance.database;
    await db.rawQuery('delete from classes where id = $id');
  }






  /// CLASSES STUDENTS


  Future insertToClassesStudents(Map<String, dynamic> map) async{
    Database db = await instance.database;
    await db.insert('classes_students', map);
    return true;
  }

  Future getAllClassesStudents() async{
    Database db = await instance.database;
    var result = await db.rawQuery('select `classes_students`.`id`,`students`.`name` as studentsName,`classes`.`name` as classesName,`classes`.`decryption` as classesDecryption from classes_students'
        ' inner join students on `students`.`id` = `classes_students`.`students_id`'
        ' inner join classes on `classes`.`id` = `classes_students`.`classes_id`');
    print(result);
    return result;
  }


  Future deleteClassesStudents({id}) async{
    Database db = await instance.database;
    await db.rawQuery('delete from classes_students where id = $id');
  }







  ///  Example of UPDATE
  // Future update({id,Map<String, Object> map}) async{
  //   Database db = await instance.database;
  //   await db.update('Product', map, where: 'id = ?', whereArgs: [id]);
  //   var result = await db.rawQuery('select * from Product where id = $id');
  //   return result;
  // }


}









