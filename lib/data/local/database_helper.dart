import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../../models/mood_entry.dart';

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
    try {
      String path = join(await getDatabasesPath(), 'mood_tracker.db');
      return await openDatabase(
        path,
        version: 1,
        onCreate: _onCreate,
      );
    } catch (e) {
      debugPrint('Ошибка инициализации базы данных: $e');
      rethrow;
    }
  }

  Future<void> _onCreate(Database db, int version) async {
    try {
      await db.execute('''
        CREATE TABLE mood_entries(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          date INTEGER NOT NULL,
          mood TEXT NOT NULL,
          note TEXT,
          rating INTEGER NOT NULL
        )
      ''');
      debugPrint('Таблица mood_entries создана успешно');
    } catch (e) {
      debugPrint('Ошибка создания таблицы: $e');
      rethrow;
    }
  }

  // Добавить запись
  Future<int> insertEntry(MoodEntry entry) async {
    try {
      final db = await database;
      final id = await db.insert('mood_entries', entry.toMap());
      debugPrint('Запись сохранена с ID: $id');
      return id;
    } catch (e) {
      debugPrint('Ошибка при сохранении записи: $e');
      rethrow;
    }
  }

  // Получить все записи
  Future<List<MoodEntry>> getEntries() async {
    try {
      final db = await database;
      final List<Map<String, dynamic>> maps = await db.query(
        'mood_entries',
        orderBy: 'date DESC',
      );
      debugPrint('Загружено записей: ${maps.length}');
      return List.generate(maps.length, (i) {
        return MoodEntry(
          id: maps[i]['id'],
          date: DateTime.fromMillisecondsSinceEpoch(maps[i]['date']),
          mood: maps[i]['mood'],
          note: maps[i]['note'],
          rating: maps[i]['rating'],
        );
      });
    } catch (e) {
      debugPrint('Ошибка при загрузке записей: $e');
      return [];
    }
  }

  // Получить записи за последние 7 дней
  Future<List<MoodEntry>> getLastWeekEntries() async {
    try {
      final db = await database;
      final weekAgo = DateTime.now().subtract(const Duration(days: 7));
      final List<Map<String, dynamic>> maps = await db.query(
        'mood_entries',
        where: 'date >= ?',
        whereArgs: [weekAgo.millisecondsSinceEpoch],
        orderBy: 'date DESC',
      );
      return List.generate(maps.length, (i) {
        return MoodEntry(
          id: maps[i]['id'],
          date: DateTime.fromMillisecondsSinceEpoch(maps[i]['date']),
          mood: maps[i]['mood'],
          note: maps[i]['note'],
          rating: maps[i]['rating'],
        );
      });
    } catch (e) {
      debugPrint('Ошибка при загрузке записей за неделю: $e');
      return [];
    }
  }

  // Удалить запись
  Future<void> deleteEntry(int id) async {
    try {
      final db = await database;
      await db.delete(
        'mood_entries',
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      debugPrint('Ошибка при удалении записи: $e');
      rethrow;
    }
  }
}