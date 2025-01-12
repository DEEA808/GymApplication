class Gym {
  final String id;
  String className;
  String trainerName;
  String description;
  String startTime;
  String endTime;
  int availableSpots;

  Gym({
    required this.id,
    required this.className,
    required this.trainerName,
    required this.description,
    required this.startTime,
    required this.endTime,
    required this.availableSpots,
  });

  // Convert a Gym object to a Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'className': className,
      'description': description,
      'trainerName': trainerName,
      'startTime': startTime,
      'endTime': endTime,
      'availableSpots': availableSpots,
    };
  }

  // Create a Gym object from a Map
  factory Gym.fromMap(Map<String, dynamic> map) {
    return Gym(
      id: map['id'] as String,
      className: map['className'] as String,
      description: map['description'] as String,
      trainerName: map['trainerName'] as String,
      startTime: map['startTime'] as String,
      endTime: map['endTime'] as String,
      availableSpots: map['availableSpots'] as int,
    );
  }
}
