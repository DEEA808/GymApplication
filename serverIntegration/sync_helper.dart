import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:gym_app_flutter/sqlite_helper.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'gym_server_helper.dart'; // For JSON decoding

class SyncHelper {
  final SQLiteHelper _dbHelper = SQLiteHelper();
  final ServerHelper _serverHelper = ServerHelper();

  Map<String, dynamic> mapServerGymToLocalGym(Map<String, dynamic> serverGym) {
    return {
      'id': serverGym['id'],
      'className': serverGym['classname'],
      // Mapping 'className' from server to local
      'trainerName': serverGym['trainername'],
      'description': serverGym['description'],
      'startTime': serverGym['starttime'],
      'endTime': serverGym['endtime'],
      'availableSpots': serverGym['availablespots'],
    };
  }

  Future<void> syncServerToLocal() async {
    try {
      final response = await http.get(Uri.parse('http://10.0.2.2:3000/gyms'));
      if (response.statusCode == 200) {
        final serverGyms = jsonDecode(response.body) as List;

        // Sync with local DB
        for (final serverGym in serverGyms) {
          debugPrint("SERVER GYM:${jsonEncode(serverGym)}");
          final localGym = await SQLiteHelper().getGymById(serverGym['id']);
          debugPrint("LOCAL GYM:${jsonEncode(localGym)}");
          if (localGym == null) {
            // Add to local DB if it doesn't exist
            await SQLiteHelper().addGym(mapServerGymToLocalGym(serverGym));
          }
        }
        debugPrint('Server data synced to local DB.');
      } else {
        debugPrint('Failed to fetch server data: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error syncing server to local: $e');
    }
  }


  Future<void> syncLocalToServer() async {
    final unsyncedChanges = await _dbHelper.getUnsyncedChanges();

    for (final change in unsyncedChanges) {
      final id = change['id'];
      final action = change['action'];

      try {
        switch (action) {
          case 'add':
            final gym = await _dbHelper.getGymById(id);
            if (gym != null) {
              await _serverHelper.addGym(gym);
            }
            break;

          case 'update':
            final gym = await _dbHelper.getGymById(id);
            if (gym != null) {
              await _serverHelper.updateGym(id, gym);
            }
            break;

          case 'delete':
            await _serverHelper.deleteGym(id);
            break;
        }

        // Remove synced change from unsynced_changes
        await _dbHelper.removeUnsyncedChange(id);
      } catch (e) {
        debugPrint('Error syncing change $action for $id: $e');
      }
    }

    debugPrint('Local changes synced to server.');
  }

  void monitorConnectivity() {
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) async {
      if (result != ConnectivityResult.none) {
        debugPrint('Internet connected, syncing data...');
        await syncLocalToServer();
        await syncServerToLocal();
      } else {
        debugPrint('No internet connection.');
      }
    });
  }
}
