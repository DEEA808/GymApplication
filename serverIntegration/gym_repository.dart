import 'package:flutter/cupertino.dart';
import 'package:gym_app_flutter/sqlite_helper.dart';

import 'gym.dart';
import 'gym_server_helper.dart';

class GymRepository {
  final SQLiteHelper _dbHelper = SQLiteHelper();
  final ServerHelper _serverHelper = ServerHelper();

  Future<List<Gym>> getGyms() async {
    final gyms = await _dbHelper.getGyms();
    return gyms.map((map) => Gym.fromMap(map)).toList();
  }

  Future<void> addGym(Gym gym) async {
    _dbHelper.addGym(gym.toMap());
    _serverHelper.sendMessage({'action': 'add', 'data': gym.toMap()});
    // Add to server
    try {
      await _serverHelper.addGym(gym.toMap());
      debugPrint("Gym successfully added to server.");
    } catch (e) {
      debugPrint("Error adding gym to server: $e");
    }
  }

  Future<void> updateGym(String id, Gym updatedGym) async {
    _dbHelper.updateGym(id, updatedGym.toMap());
    _serverHelper.sendMessage({'action': 'update', 'data': updatedGym.toMap()});
    try {
      await _serverHelper.updateGym(id,updatedGym.toMap());
      debugPrint("Gym successfully added to server.");
    } catch (e) {
      debugPrint("Error adding gym to server: $e");
    }
  }

  Future<void> deleteGym(String id) async {
    _dbHelper.deleteGym(id);

    // Send correct WebSocket message
    _serverHelper.sendMessage({
      'action': 'delete',
      'data': {'id': id}, // Wrapping id in "data" as expected by the server
    });

    try {
      await _serverHelper.deleteGym(id); // If this calls another server method, ensure it's handled correctly
      debugPrint("Gym successfully deleted from server.");
    } catch (e) {
      debugPrint("Error deleting gym from server: $e");
    }
  }

}
