class Challenge {
  final int id;
  final String title;
  final String description;
  final String type;
  final int goal;
  final String reward;
  final DateTime startDate;
  final DateTime endDate;

  Challenge({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.goal,
    required this.reward,
    required this.startDate,
    required this.endDate,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'description': description,
        'type': type,
        'goal': goal,
        'reward': reward,
        'start_date': startDate.toIso8601String(),
        'end_date': endDate.toIso8601String(),
      };

  factory Challenge.fromMap(Map<String, dynamic> map) => Challenge(
        id: map['id'],
        title: map['title'],
        description: map['description'],
        type: map['type'],
        goal: map['goal'],
        reward: map['reward'],
        startDate: DateTime.parse(map['start_date']),
        endDate: DateTime.parse(map['end_date']),
      );
}
