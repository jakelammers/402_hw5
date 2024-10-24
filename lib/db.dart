import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'models/metadata.dart';

class Db {
  static final Db _instance = Db._internal();
  factory Db() => _instance;

  Db._internal();

  static Database? _db;

  Future<Database> get instance async {
    if (_db != null) return _db!;

    _db = await _initDB();
    return _db!;
  }

  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'windowpane.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE photos (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        path TEXT NOT NULL,
        timestamp TEXT,
        description TEXT,
        location TEXT
      )
    ''');
  }

  Future<int> insertPhoto(PhotoMetadata photo) async {
    final db = await instance;
    return await db.insert('photos', photo.toMap());
  }

  Future<List<PhotoMetadata>> getPhotos() async {
    final db = await instance;
    final maps = await db.query('photos');

    return List.generate(maps.length, (i) {
      return PhotoMetadata.fromMap(maps[i]);
    });
  }

  Future<int> deletePhoto(int id) async {
    final db = await instance;
    return await db.delete('photos', where: 'id = ?', whereArgs: [id]);
  }
}
