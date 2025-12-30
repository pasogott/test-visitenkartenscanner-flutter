import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/business_card.dart';

class DatabaseService {
  static Database? _database;
  static const String _tableName = 'business_cards';
  static bool _initialized = false;

  static void initializeForWeb() {
    if (kIsWeb && !_initialized) {
      databaseFactory = databaseFactoryFfiWeb;
      _initialized = true;
    }
  }

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path;
    if (kIsWeb) {
      path = 'visitenkarten.db';
    } else {
      final dbPath = await getDatabasesPath();
      path = join(dbPath, 'visitenkarten.db');
    }

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $_tableName (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        front_image_path TEXT NOT NULL,
        back_image_path TEXT,
        selfie_image_path TEXT,
        created_at TEXT NOT NULL,
        notes TEXT
      )
    ''');
  }

  Future<int> insertCard(BusinessCard card) async {
    final db = await database;
    return await db.insert(_tableName, card.toMap());
  }

  Future<List<BusinessCard>> getAllCards() async {
    final db = await database;
    final maps = await db.query(
      _tableName,
      orderBy: 'created_at DESC',
    );
    return maps.map((map) => BusinessCard.fromMap(map)).toList();
  }

  Future<BusinessCard?> getCard(int id) async {
    final db = await database;
    final maps = await db.query(
      _tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isEmpty) return null;
    return BusinessCard.fromMap(maps.first);
  }

  Future<int> updateCard(BusinessCard card) async {
    final db = await database;
    return await db.update(
      _tableName,
      card.toMap(),
      where: 'id = ?',
      whereArgs: [card.id],
    );
  }

  Future<int> deleteCard(int id) async {
    final db = await database;
    return await db.delete(
      _tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
