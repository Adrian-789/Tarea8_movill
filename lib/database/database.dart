// database.dart

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseManager {
  late Database _database;

  Future<void> initializeDatabase() async {
    _database = await openDatabase(
      join(await getDatabasesPath(), 'registros_database.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE registros(id INTEGER PRIMARY KEY, titulo TEXT, fecha INTEGER, descripcion TEXT, foto TEXT, audio TEXT)',
        );
      },
      version: 1,
    );
  }

  Future<void> insertRegistro(Map<String, dynamic> registro) async {
    await _database.insert(
      'registros',
      registro,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> getAllRegistros() async {
    return await _database.query('registros');
  }

  Future<void> deleteAllRegistros() async {
    await _database.delete('registros');
  }
}
