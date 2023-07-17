// import 'package:sqflite/sqflite.dart' as sql;
// import 'package:flutter/foundation.dart';
//
// class SQLHelper {
//
//   ///function for creating a discussions table table in a database
//   static Future<void> createTable(sql.Database database) async{
//
//     await database.execute("""CREATE TABLE discussions(
//     discId  INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
//     discName TEXT,
//     createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
//     )""");
//   }
//
//   ///CONNECT DATABASE
//   static Future<sql.Database> dbConnect() async{
//     return sql.openDatabase(
//         'davies.db',
//         version: 1,
//         onCreate: (sql.Database database, int version) async{
//           print('++++++++++Creating a Table---------');
//           await createTable(database);
//         }
//     );
//
//   }
//
//   ///INSERT
//   static Future<int> createItem(String discName) async{
//
//     final db = await SQLHelper.dbConnect(); //connecting to the db
//     final data = {'discName': discName}; // putting data in a map format
//     final id = await db.insert('discussions', data, //inserting the data in a table 'items'
//         conflictAlgorithm: sql.ConflictAlgorithm.replace  // prevents duplicate entry
//     );
//     return id; //returns an id of that row in a database
//
//   }
//
//   ///SELECTING all
//   static Future<List<Map<String, dynamic>>> getItems() async{
//     final db = await SQLHelper.dbConnect(); //connecting to the database
//     return db.query('discussions', orderBy: "discId DESC"); // selecting data from the database 'items'
//   }
//
//
//
//
//   ///function for getting a single item in a database
//   static Future<List<Map<String, dynamic>>> getItem(int id) async{
//     final db = await SQLHelper.dbConnect();
//     return db.query('discussions', where: "discId = ?", whereArgs: [id], limit: 1);
//   }
//
//   ///function to update an item in a database
//   static Future<int> updateItem(String id, String? discName) async{
//     final db = await SQLHelper.dbConnect();
//     final data = {'discName': discName}; // putting data in a map format
//
//     final result = await db.update('discussions', data, where: "discId = ?", whereArgs: [id]);
//
//     return result;
//   }
//
//   ///function to delete an item in a database
//
//   static Future<void> deleteItem(int id) async{
//
//     final db = await SQLHelper.dbConnect(); //connection to the db
//     try{
//       await db.delete("discussions", where: "discId = ?", whereArgs: [id]);
//     } catch(e){
//       debugPrint('Something went wrong: $e');
//     }
//
//   }
//
//
//
//
// }