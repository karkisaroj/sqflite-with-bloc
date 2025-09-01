import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class ProductHelper {
  static final ProductHelper instance = ProductHelper._internal();
  factory ProductHelper() => instance;
  ProductHelper._internal();
  Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await initDb();
    return _db!;
  }

  //initialize the datavase
  Future<Database> initDb() async {
    var getDatabasePath = await getDatabasesPath();
    String path = join(getDatabasePath, 'ProductDatabase.db');
    Database database = await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute(
          'CREATE TABLE Products(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, description TEXT)',
        );
      },
    );
    return database;
  }

  // Insert a product in the database
  Future<int> insertProduct(Map<String, dynamic> product) async {
    final db = await database;
    return await db.insert('Products', product);
  }

  // Get all products in the datavase
  Future<List<Map<String, dynamic>>> getProducts() async {
    final db = await database;
    return await db.query('Products');
  }

  // Update a product in the database
  Future<int> updateProduct(int id, Map<String, dynamic> product) async {
    final db = await database;
    return await db.update(
      'Products',
      product,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Delete a product in database
  Future<int> deleteProduct(int id) async {
    final db = await database;
    return await db.delete('Products', where: 'id = ?', whereArgs: [id]);
  }
}
