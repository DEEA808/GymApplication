import 'package:sqlite3/sqlite3.dart';

class SQLiteHelper {
  late Database db;

  SQLiteHelper() {
    _initDatabase();
  }

  void _initDatabase() {
    String path= '/data/data/com.example.gym_app_flutter/databases/gym.db';
    db = sqlite3.open(path);
    _createTableIfNotExists();
  }

  void _createTableIfNotExists() {
    db.execute('''
      CREATE TABLE IF NOT EXISTS gyms (
        id TEXT PRIMARY KEY,
        className TEXT NOT NULL,
        description TEXT NOT NULL,
        trainerName TEXT NOT NULL,
        startTime TEXT NOT NULL,
        endTime TEXT NOT NULL,
        availableSpots INTEGER NOT NULL
      )
    ''');
  }

  Future<void> addGym(Map<String, dynamic> gym) async {
    db.execute('''
      INSERT INTO gyms (id, className, description, trainerName, startTime, endTime, availableSpots)
      VALUES (?, ?, ?, ?, ?, ?, ?)
    ''', [
      gym['id'],
      gym['className'],
      gym['description'],
      gym['trainerName'],
      gym['startTime'],
      gym['endTime'],
      gym['availableSpots'],
    ]);
  }

  Future<void> updateGym(String id, Map<String, dynamic> updatedGym) async {
    db.execute(''' 
      UPDATE gyms 
      SET className = ?, description = ?, trainerName = ?, startTime = ?, endTime = ?, availableSpots = ? 
      WHERE id = ? 
    ''', [
      updatedGym['className'],
      updatedGym['description'],
      updatedGym['trainerName'],
      updatedGym['startTime'],
      updatedGym['endTime'],
      updatedGym['availableSpots'],
      id,
    ]);
  }

  Future<void> deleteGym(String id) async {
    db.execute(''' 
      DELETE FROM gyms WHERE id = ? 
    ''', [id]);
  }

  Future<List<Map<String, dynamic>>> getGyms() async {
    final result = db.select('SELECT * FROM gyms');
    return result.map((row) {
      return {
        'id': row['id'] as String,
        'className': row['className'] as String,
        'description': row['description'] as String,
        'trainerName': row['trainerName'] as String,
        'startTime': row['startTime'] as String,
        'endTime': row['endTime'] as String,
        'availableSpots': row['availableSpots'] as int,
      };
    }).toList();
  }
}
