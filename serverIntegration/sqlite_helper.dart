import 'package:sqlite3/sqlite3.dart';

import 'gym.dart';

class SQLiteHelper {
  late Database db;

  SQLiteHelper() {
    _initDatabase();
  }

  void _initDatabase() {
    String path = '/data/data/com.example.gym_app_flutter/databases/gym.db';
    db = sqlite3.open(path);
    _createTablesIfNotExist();
  }

  void _createTablesIfNotExist() {
    // Create the `gyms` table
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

    // Create the `unsynced_changes` table
    db.execute('''
      CREATE TABLE IF NOT EXISTS unsynced_changes (
        id TEXT PRIMARY KEY,
        action TEXT NOT NULL
      )
    ''');
  }

  // Track unsynced changes
  Future<void> markUnsyncedChange(String id, String action) async {
    db.execute('''
      INSERT INTO unsynced_changes (id, action)
      VALUES (?, ?)
      ON CONFLICT(id) DO UPDATE SET action = excluded.action
    ''', [id, action]);
  }

  // Add gym
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
    await markUnsyncedChange(gym['id'], 'add');
  }

  // Update gym
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
    await markUnsyncedChange(id, 'update');
  }

  // Delete gym
  Future<void> deleteGym(String id) async {
    db.execute('''
      DELETE FROM gyms WHERE id = ?
    ''', [id]);
    await markUnsyncedChange(id, 'delete');
  }

  // Get all gyms
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

  Future<Map<String, Object?>?> getGymById(String id) async {
    final result = db.select('SELECT * FROM gyms WHERE id = ?', [id]);
    if (result.isNotEmpty) {
      final row = result.first;
      return {
        'id': row['id'] as String,
        'className': row['className'] as String,
        'description': row['description'] as String,
        'trainerName': row['trainerName'] as String,
        'startTime': row['startTime'] as String,
        'endTime': row['endTime'] as String,
        'availableSpots': row['availableSpots'] as int,
      };
    }
    return null;
  }


  // Get all unsynced changes
  Future<List<Map<String, dynamic>>> getUnsyncedChanges() async {
    final result = db.select('SELECT * FROM unsynced_changes');
    return result.map((row) {
      return {
        'id': row['id'] as String,
        'action': row['action'] as String,
      };
    }).toList();
  }

  // Remove synced change from `unsynced_changes`
  Future<void> removeUnsyncedChange(String id) async {
    db.execute('DELETE FROM unsynced_changes WHERE id = ?', [id]);
  }
}
