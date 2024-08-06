import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/blogModel.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'blog_database.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE blogs (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT,
            imageUrl TEXT
          )
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < newVersion) {
          final result = await db.rawQuery('PRAGMA table_info(blogs)');
          bool columnExists = result.any((row) => row['name'] == 'imageUrl');

          if (!columnExists) {
            await db.execute('''
              ALTER TABLE blogs ADD COLUMN imageUrl TEXT
            ''');
          }
          await printSchema();
        }
      },
    );
  }

  Future<void> insertBlog(Blog blog) async {
    final db = await database;
    await db.insert(
      'blogs',
      blog.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Blog>> getBlogs() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('blogs');
    return List.generate(maps.length, (i) {
      return Blog.fromJson(maps[i]);
    });
  }

  Future<void> clearBlogs() async {
    final db = await database;
    await db.delete('blogs');
  }

  Future<void> printSchema() async {
    final db = await database;
    final result = await db.rawQuery('PRAGMA table_info(blogs)');
    print('Schema: $result');
  }
}
