import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/metadata.dart';

/**
 * @author jakelammers & claude 3.5
 * @date 10-24-24
 *
 * photo service for hte windowpane app
 */
class PhotoService {
  static Database? _database;

  Future<Database> get database async {
    _database ??= await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    String path = join(await getDatabasesPath(), 'windowpane.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('''
          CREATE TABLE photos(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            path TEXT,
            timestamp TEXT,
            description TEXT,
            location TEXT,
            weather TEXT
          )
        ''');
      },
    );
  }

  Future<void> savePhoto(PhotoMetadata photo) async {
    final db = await database;
    await db.insert('photos', photo.toMap());
  }

  Future<List<PhotoMetadata>> getPhotos({String? search}) async {
    final db = await database;
    List<Map<String, dynamic>> maps;

    if (search != null && search.isNotEmpty) {
      maps = await db.query(
        'photos',
        where: 'description LIKE ?',
        whereArgs: ['%$search%'],
      );
    } else {
      maps = await db.query('photos');
    }

    return List.generate(maps.length, (i) => PhotoMetadata.fromMap(maps[i]));
  }

  Future<int> deletePhoto(int id) async {
    final db = await database;
    return await db.delete(
      'photos',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}