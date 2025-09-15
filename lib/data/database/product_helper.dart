import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class ProductHelper {
  static final instance = ProductHelper._internal();
  factory ProductHelper() => instance;
  ProductHelper._internal();
  Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await initDb();
    return _db!;
  }

  Future<Database> initDb() async {
    var getDatabasePath = await getDatabasesPath();
    String path = join(getDatabasePath, 'Product_database.db');

    Database database = await openDatabase(
      path,
      version: 4,
      onCreate: (Database db, version) async {
        await db.execute(
          'CREATE TABLE Products(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, description TEXT, favourites INTEGER,categories TEXT,rating REAL,quantity INTEGER)',
        );
        await db.execute(
          'CREATE TABLE Cart(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, description TEXT, favourites INTEGER, categories TEXT, rating REAL, quantity INTEGER)',
        );
      },
    );
    return database;
  }

  // CART PERSISTENCE
  Future<int> insertCartProduct(Map<String, dynamic> product) async {
    final db = await database;
    return await db.insert('Cart', product);
  }

  Future<List<Map<String, dynamic>>> getCartProducts() async {
    final db = await database;
    return await db.query('Cart');
  }

  Future<int> updateCartProduct(int id, Map<String, dynamic> product) async {
    final db = await database;
    return await db.update('Cart', product, where: 'id=?', whereArgs: [id]);
  }

  Future<int> deleteCartProduct(int id) async {
    final db = await database;
    return await db.delete('Cart', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> clearCart() async {
    final db = await database;
    await db.delete('Cart');
  }

  Future<int> insertProduct(Map<String, dynamic> product) async {
    final db = await database;
    return await db.insert('Products', product);
  }

  Future<List<Map<String, dynamic>>> getProducts() async {
    final db = await database;
    return await db.query('Products');
  }

  Future<int> updateProducts(int id, Map<String, dynamic> products) async {
    final db = await database;
    return await db.update(
      'Products',
      products,
      where: 'id=?',
      whereArgs: [id],
    );
  }

  Future<int> deleteProduct(int id) async {
    final db = await database;
    return await db.delete('Products', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> deleteDatabaseFile() async {
    var getDatabasePath = await getDatabasesPath();
    String path = join(getDatabasePath, 'Product_database.db');
    await deleteDatabase(path);
    _db = null;
  }
}
