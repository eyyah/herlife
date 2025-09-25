import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:myapp/models/user_model.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDb();
    return _database!;
  }

  Future<Database> _initDb() async {
    String path = join(await getDatabasesPath(), 'user.db');
    return await openDatabase(
      path,
      version: 3, // Incremented version to apply new schema
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute(
      'CREATE TABLE users(id INTEGER PRIMARY KEY AUTOINCREMENT, email TEXT UNIQUE, username TEXT UNIQUE, password TEXT)',
    );
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 3) {
      // Simple upgrade strategy: drop and recreate
      await db.execute('DROP TABLE IF EXISTS users');
      await _onCreate(db, newVersion);
    }
  }

  Future<int> saveUser(User user) async {
    var dbClient = await database;
    return await dbClient.insert('users', user.toMap(), conflictAlgorithm: ConflictAlgorithm.fail);
  }

  Future<User?> getUser(String username, String password) async {
    var dbClient = await database;
    var res = await dbClient.query(
      'users',
      where: 'username = ? AND password = ?',
      whereArgs: [username, password],
    );
    if (res.isNotEmpty) {
      return User.fromMap(res.first);
    }
    return null;
  }
}
