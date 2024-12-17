import 'package:sqlite3/sqlite3.dart';
import 'gym.dart';
import 'sqlite_helper.dart';

class GymRepository {
  final SQLiteHelper _dbHelper = SQLiteHelper();

  Future<List<Gym>> getGyms() async {
    final gymMaps = await _dbHelper.getGyms();

    return gymMaps.map((map) => Gym(
      id: map['id'],
      className: map['className'],
      description: map['description'],
      trainerName: map['trainerName'],
      startTime: map['startTime'],
      endTime: map['endTime'],
      availableSpots: map['availableSpots'],
    )).toList();
  }

  void addGym(Gym gym) {
    _dbHelper.addGym({
      'id': gym.id,
      'className': gym.className,
      'description': gym.description,
      'trainerName': gym.trainerName,
      'startTime': gym.startTime,
      'endTime': gym.endTime,
      'availableSpots': gym.availableSpots,
    });
  }

  void updateGym(String id, Gym updatedGym) {
    _dbHelper.updateGym(id, {
      'id': updatedGym.id,
      'className': updatedGym.className,
      'description': updatedGym.description,
      'trainerName': updatedGym.trainerName,
      'startTime': updatedGym.startTime,
      'endTime': updatedGym.endTime,
      'availableSpots': updatedGym.availableSpots,
    });
  }

  void deleteGym(String id) {
    _dbHelper.deleteGym(id);
  }
}
