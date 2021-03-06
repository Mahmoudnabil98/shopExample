import 'package:flutter_shop/constance.dart';
import 'package:flutter_shop/model/cart_prodauct_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class CartDatabaseHelper {
  CartDatabaseHelper._();

  static final CartDatabaseHelper db = CartDatabaseHelper._();

  static Database _database;

  Future<Database> get database async {

    if (_database != null) 
      return _database;

      _database = await initDb();

      return _database;
    


  }

  initDb() async {
    String path = join(await getDatabasesPath(), 'CartProduct.db');

    return await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
       return await db.execute(''' 
          CREATE TABLE $tableCartProduct (
            $columnName TEXT NOT NULL,
            $columnImage TEXT NOT NULL,
            $columnPrice TEXT NOT NULL,
            $columnQuantity INTEGER NOT NULL,)
          
          ''');  
    });
    
  }
  Future<List<CartProductModel>> getAllProduct()async{
     var dbClient = await database;
     List<Map> maps = await dbClient.query(tableCartProduct);

     List<CartProductModel> list = maps.isNotEmpty ?
     maps.map((product) => CartProductModel.formJson(product)).toList()
     : [];
     return list;

   }

  Future<void>insert(CartProductModel cartProductModel)async{
    var dbClient = await database;
    await dbClient.insert(tableCartProduct,cartProductModel.toJson(),conflictAlgorithm: ConflictAlgorithm.replace );

    }
}
