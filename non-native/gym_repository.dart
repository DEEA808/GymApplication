import 'gym.dart';

class GymRepository {
  final List<Gym> _gyms = [Gym(
      id : "1",
      className : "Yoga Basics",
      description : "aaa",
      trainerName : "Alice",
      startTime : "6:00",
      endTime : "7:00",
      availableSpots : 20
  ),
    Gym(
        id : "2",
        className : "HIIT Workout",
        trainerName : "Bob",
        description : "bbb",
        startTime : "4:00",
        endTime : "5:00",
        availableSpots : 15
    ),
    Gym(
        id : "3",
        className : "Pilates",
        description : "aaa",
        trainerName : "Cathy",
        startTime : "2024-11-12",
        endTime : "2024-11-12",
        availableSpots : 10
    )];

  List<Gym> get gyms => _gyms;

  void addGym(Gym gym) {
    _gyms.add(gym);
  }

  void updateGym(String id, Gym updatedGym) {
    final index = _gyms.indexWhere((gym) => gym.id == id);
    if (index != -1) {
      _gyms[index] = updatedGym;
    }
  }

  void deleteGym(String id) {
    _gyms.removeWhere((gym) => gym.id == id);
  }
}
