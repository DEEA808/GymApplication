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
}
