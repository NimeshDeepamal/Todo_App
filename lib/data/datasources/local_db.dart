import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/task_dto.dart';

class LocalDb {
  static const _dbName = 'todo_db.db';
  static const _taskTable = 'tasks';

  static Database? _instance;

  static Future<Database> get database async {
    if (_instance != null) return _instance!;
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _dbName);

    _instance = await openDatabase(
      path,
      version: 1,
      onCreate: (db, v) async {
        await db.execute('''
          CREATE TABLE $_taskTable(
            id TEXT PRIMARY KEY,
            title TEXT,
            description TEXT,
            dueDate INTEGER,
            completed INTEGER,
            userId TEXT
          )
        ''');
      },
    );
    return _instance!;
  }

  static Future<List<TaskDto>> getAllTasks(String userId) async {
    final db = await database;
    final maps = await db.query(
      _taskTable,
      where: 'userId = ?',
      whereArgs: [userId],
      orderBy: 'dueDate ASC',
    );
    return maps.map((m) => TaskDto.fromMap(m)).toList();
  }

  static Future<void> insertTask(TaskDto dto) async {
    final db = await database;
    await db.insert(
      _taskTable,
      dto.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<void> updateTask(TaskDto dto) async {
    final db = await database;
    await db.update(
      _taskTable,
      dto.toMap(),
      where: 'id = ? AND userId = ?',
      whereArgs: [dto.id, dto.userId],
    );
  }

  static Future<void> deleteTask(String id, String userId) async {
    final db = await database;
    await db.delete(
      _taskTable,
      where: 'id = ? AND userId = ?',
      whereArgs: [id, userId],
    );
  }

  static Future<void> clearTasks(String userId) async {
    final db = await database;
    await db.delete(_taskTable, where: 'userId = ?', whereArgs: [userId]);
  }
}