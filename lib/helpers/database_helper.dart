import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static Database? _database;

  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  static Future<Database> _initDatabase() async {
    final path = join(await getDatabasesPath(), 'veritabani.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute(
          'CREATE TABLE kullanicilar(id INTEGER PRIMARY KEY, kullanici_adi TEXT, sifre TEXT)',
        );
        await db.execute(
          'CREATE TABLE kategoriler(id INTEGER PRIMARY KEY AUTOINCREMENT, ad TEXT)',
        );
        await db.execute(
          'CREATE TABLE urunler(id INTEGER PRIMARY KEY AUTOINCREMENT, ad TEXT, fiyat REAL, stok INTEGER, kategori_id INTEGER, FOREIGN KEY (kategori_id) REFERENCES kategoriler (id))',
        );
      },
    );
  }

  static Future<void> ensureDefaultUsers() async {
    final db = await database;
    
    // Check if users exist
    final adminExists = await db.query(
      'kullanicilar',
      where: 'kullanici_adi = ?',
      whereArgs: ['admin'],
    );
    
    final esatExists = await db.query(
      'kullanicilar',
      where: 'kullanici_adi = ?',
      whereArgs: ['esat'],
    );

    // Add users if they don't exist
    if (adminExists.isEmpty) {
      await db.insert(
        'kullanicilar',
        {'kullanici_adi': 'admin', 'sifre': '1234'},
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    if (esatExists.isEmpty) {
      await db.insert(
        'kullanicilar',
        {'kullanici_adi': 'esat', 'sifre': '1234'},
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  static Future<bool> validateUser(String username, String password) async {
    final db = await database;
    final result = await db.query(
      'kullanicilar',
      where: 'kullanici_adi = ? AND sifre = ?',
      whereArgs: [username, password],
    );
    return result.isNotEmpty;
  }

  static Future<List<Map<String, dynamic>>> getKategoriler() async {
    final db = await database;
    return await db.query('kategoriler');
  }

  static Future<Map<String, dynamic>?> getKategori(int id) async {
    final db = await database;
    final result = await db.query(
      'kategoriler',
      where: 'id = ?',
      whereArgs: [id],
    );
    return result.isNotEmpty ? result.first : null;
  }

  static Future<List<Map<String, dynamic>>> getUrunler({int? kategoriId}) async {
    final db = await database;
    if (kategoriId == null) {
      return await db.query('urunler');
    }
    return await db.query(
      'urunler',
      where: 'kategori_id = ?',
      whereArgs: [kategoriId],
    );
  }

  static Future<int> addUrun(String ad, double fiyat, int stok, int kategoriId) async {
    final db = await database;
    return await db.insert(
      'urunler',
      {
        'ad': ad,
        'fiyat': fiyat,
        'stok': stok,
        'kategori_id': kategoriId,
      },
    );
  }

  static Future<int> updateUrun(int id, String ad, double fiyat, int stok, int kategoriId) async {
    final db = await database;
    return await db.update(
      'urunler',
      {
        'ad': ad,
        'fiyat': fiyat,
        'stok': stok,
        'kategori_id': kategoriId,
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  static Future<int> deleteUrun(int id) async {
    final db = await database;
    return await db.delete(
      'urunler',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
