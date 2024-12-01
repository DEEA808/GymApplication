import 'package:flutter/material.dart';
import 'gym.dart';
import 'gym_repository.dart';

class GymViewModel extends ChangeNotifier {
  final GymRepository _repository = GymRepository();

  List<Gym> get gyms => _repository.gyms;

  void addGym(Gym gym) {
    _repository.addGym(gym);
    notifyListeners();
  }

  void updateGym(String id, Gym updatedGym) {
    _repository.updateGym(id, updatedGym);
    notifyListeners();
  }

  void deleteGym(String id) {
    _repository.deleteGym(id);
    notifyListeners();
  }
}
