import 'package:flutter/material.dart';
import 'gym.dart';
import 'gym_repository.dart';

class GymViewModel extends ChangeNotifier {
  final GymRepository _gymRepository = GymRepository();
  List<Gym> _gyms = [];
  String? _errorMessage;

  List<Gym> get gyms => _gyms;

  String? get errorMessage => _errorMessage;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> loadGyms() async {
    _isLoading = true;
    notifyListeners();

    try {
      final gymsFromDb = await _gymRepository.getGyms();
      _gyms = gymsFromDb;
      _errorMessage = null;
    } catch (e) {
      _errorMessage = 'Failed to load gyms: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void addGym(Gym gym) {
    _gyms.add(gym);
    _gymRepository.addGym(gym);
    notifyListeners();
  }

  void updateGym(String id, Gym updatedGym) {
    final index = _gyms.indexWhere((gym) => gym.id == id);
    if (index != -1) {
      _gyms[index] = updatedGym;
      _gymRepository.updateGym(id, updatedGym);
      notifyListeners();
    }
  }

  void deleteGym(String id) {
    _gyms.removeWhere((gym) => gym.id == id);
    _gymRepository.deleteGym(id);
    notifyListeners();
  }
}
