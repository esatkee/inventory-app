// main.dart
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:hafta14/screens/login_screen.dart';
import 'package:hafta14/helpers/database_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize database and add sample data if needed
  await _initializeDatabase();
  
  runApp(const MyApp());
}

Future<void> _initializeDatabase() async {
  final db = await DatabaseHelper.database;
  
  // Always ensure default users exist
  await DatabaseHelper.ensureDefaultUsers();
  
  // Check if this is the first run for categories
  final kategoriler = await db.query('kategoriler');
  if (kategoriler.isEmpty) {
    await db.insert('kategoriler', {'ad': 'Elektronik'});
    await db.insert('kategoriler', {'ad': 'Giyim'});
    await db.insert('kategoriler', {'ad': 'Gıda'});
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mobil Uygulama Dersi',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const LoginScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}